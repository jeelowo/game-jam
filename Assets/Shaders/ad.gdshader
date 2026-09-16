shader_type canvas_item;

// ============================================================
// SCREEN TEXTURE
// ============================================================

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


// ============================================================
// SETTINGS
// ============================================================

// Overlay
uniform bool overlay = true;


// Scanlines
uniform float scanlines_opacity : hint_range(0.0, 1.0) = 0.15;
uniform float scanlines_width : hint_range(0.0, 0.5) = 0.25;


// CRT grille
uniform float grille_opacity : hint_range(0.0, 1.0) = 0.10;


// Resolution used for CRT effects
uniform vec2 resolution = vec2(640.0, 480.0);


// Pixelation
uniform bool pixelate = false;


// VHS rolling distortion
uniform bool roll = false;
uniform float roll_speed = 8.0;
uniform float roll_size : hint_range(0.0, 100.0) = 15.0;
uniform float roll_variation : hint_range(0.1, 5.0) = 1.8;
uniform float distort_intensity : hint_range(0.0, 0.2) = 0.05;


// VHS noise
uniform float noise_opacity : hint_range(0.0, 1.0) = 0.10;
uniform float noise_speed = 5.0;


// Static
uniform float static_noise_intensity : hint_range(0.0, 1.0) = 0.02;


// Chromatic aberration
uniform float aberration : hint_range(-1.0, 1.0) = 0.01;


// Brightness
uniform float brightness = 1.2;


// VHS discoloration
uniform bool discolor = false;


// CRT curvature
uniform float warp_amount : hint_range(0.0, 5.0) = 0.5;


// Clip warped edges
uniform bool clip_warp = false;


// Vignette
uniform float vignette_intensity = 0.4;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.35;


// ============================================================
// RANDOM
// ============================================================

vec2 random(vec2 uv)
{
	uv = vec2(
		dot(uv, vec2(127.1, 311.7)),
		dot(uv, vec2(269.5, 183.3))
	);

	return -1.0 + 2.0 * fract(
		sin(uv) * 43758.5453123
	);
}


// ============================================================
// NOISE
// ============================================================

float noise(vec2 uv)
{
	vec2 uv_index = floor(uv);
	vec2 uv_fract = fract(uv);

	vec2 blur = smoothstep(
		0.0,
		1.0,
		uv_fract
	);

	return mix(
		mix(
			dot(
				random(uv_index + vec2(0.0, 0.0)),
				uv_fract - vec2(0.0, 0.0)
			),
			dot(
				random(uv_index + vec2(1.0, 0.0)),
				uv_fract - vec2(1.0, 0.0)
			),
			blur.x
		),
		mix(
			dot(
				random(uv_index + vec2(0.0, 1.0)),
				uv_fract - vec2(0.0, 1.0)
			),
			dot(
				random(uv_index + vec2(1.0, 1.0)),
				uv_fract - vec2(1.0, 1.0)
			),
			blur.x
		),
		blur.y
	) * 0.5 + 0.5;
}


// ============================================================
// CRT WARP
// ============================================================

vec2 warp(vec2 uv)
{
	vec2 delta = uv - 0.5;

	float delta2 = dot(
		delta,
		delta
	);

	float delta4 = delta2 * delta2;

	float delta_offset =
		delta4 * warp_amount;

	return uv + delta * delta_offset;
}


// ============================================================
// CRT BORDER
// ============================================================

float border(vec2 uv)
{
	float radius = min(
		warp_amount,
		0.08
	);

	radius = max(
		min(
			min(
				abs(radius * 2.0),
				abs(1.0)
			),
			abs(1.0)
		),
		1e-5
	);

	vec2 abs_uv =
		abs(uv * 2.0 - 1.0)
		- vec2(1.0)
		+ radius;

	float dist =
		length(
			max(vec2(0.0), abs_uv)
		) / radius;

	float square =
		smoothstep(
			0.96,
			1.0,
			dist
		);

	return clamp(
		1.0 - square,
		0.0,
		1.0
	);
}


// ============================================================
// VIGNETTE
// ============================================================

float vignette(vec2 uv)
{
	uv *= 1.0 - uv.xy;

	float vignette_value =
		uv.x * uv.y * 15.0;

	return pow(
		vignette_value,
		vignette_intensity *
		vignette_opacity
	);
}


// ============================================================
// FRAGMENT
// ============================================================

void fragment()
{
	// Get screen UV
	vec2 uv;

	if (overlay)
	{
		uv = warp(SCREEN_UV);
	}
	else
	{
		uv = warp(UV);
	}


	vec2 text_uv = uv;

	vec2 roll_uv = vec2(0.0);


	// ========================================================
	// PIXELATION
	// ========================================================

	if (pixelate)
	{
		text_uv =
			ceil(uv * resolution)
			/ resolution;
	}


	// ========================================================
	// ROLLING VHS DISTORTION
	// ========================================================

	float roll_line = 0.0;

	float time = roll
		? TIME
		: 0.0;


	if (roll || noise_opacity > 0.0)
	{
		roll_line =
			smoothstep(
				0.3,
				0.9,
				sin(
					uv.y * roll_size
					- time * roll_speed
				)
			);


		roll_line *= roll_line;


		roll_line *=
			smoothstep(
				0.3,
				0.9,
				sin(
					uv.y *
					roll_size *
					roll_variation
					-
					time *
					roll_speed *
					roll_variation
				)
			);


		roll_uv = vec2(
			roll_line *
			distort_intensity *
			(1.0 - UV.x),
			0.0
		);
	}


	// ========================================================
	// SAMPLE SCREEN
	// ========================================================

	vec4 text;


	if (roll)
	{
		text.r =
			texture(
				SCREEN_TEXTURE,
				text_uv +
				roll_uv * 0.8 +
				vec2(aberration, 0.0) * 0.1
			).r;


		text.g =
			texture(
				SCREEN_TEXTURE,
				text_uv +
				roll_uv * 1.2 -
				vec2(aberration, 0.0) * 0.1
			).g;


		text.b =
			texture(
				SCREEN_TEXTURE,
				text_uv +
				roll_uv
			).b;


		text.a = 1.0;
	}
	else
	{
		text.r =
			texture(
				SCREEN_TEXTURE,
				text_uv +
				vec2(aberration, 0.0) * 0.1
			).r;


		text.g =
			texture(
				SCREEN_TEXTURE,
				text_uv -
				vec2(aberration, 0.0) * 0.1
			).g;


		text.b =
			texture(
				SCREEN_TEXTURE,
				text_uv
			).b;


		text.a = 1.0;
	}


	// ========================================================
	// RGB VALUES
	// ========================================================

	float r = text.r;
	float g = text.g;
	float b = text.b;


	uv = warp(UV);


	// ========================================================
	// CRT RGB GRILLE
	// ========================================================

	if (grille_opacity > 0.0)
	{
		float g_r =
			smoothstep(
				0.85,
				0.95,
				abs(
					sin(
						uv.x *
						(resolution.x *
						3.14159265)
					)
				)
			);


		r = mix(
			r,
			r * g_r,
			grille_opacity
		);


		float g_g =
			smoothstep(
				0.85,
				0.95,
				abs(
					sin(
						1.05 +
						uv.x *
						(resolution.x *
						3.14159265)
					)
				)
			);


		g = mix(
			g,
			g * g_g,
			grille_opacity
		);


		float b_b =
			smoothstep(
				0.85,
				0.95,
				abs(
					sin(
						2.1 +
						uv.x *
						(resolution.x *
						3.14159265)
					)
				)
			);


		b = mix(
			b,
			b * b_b,
			grille_opacity
		);
	}


	// ========================================================
	// BRIGHTNESS
	// ========================================================

	text.r =
		clamp(
			r * brightness,
			0.0,
			1.0
		);

	text.g =
		clamp(
			g * brightness,
			0.0,
			1.0
		);

	text.b =
		clamp(
			b * brightness,
			0.0,
			1.0
		);


	// ========================================================
	// SCANLINES
	// ========================================================

	float scanlines = 0.5;


	if (scanlines_opacity > 0.0)
	{
		scanlines =
			smoothstep(
				scanlines_width,
				scanlines_width + 0.5,
				abs(
					sin(
						uv.y *
						(resolution.y *
						3.14159265)
					)
				)
			);


		text.rgb =
			mix(
				text.rgb,
				text.rgb *
				vec3(scanlines),
				scanlines_opacity
			);
	}


	// ========================================================
	// MOVING NOISE
	// ========================================================

	if (noise_opacity > 0.0)
	{
		float moving_noise =
			smoothstep(
				0.4,
				0.5,
				noise(
					uv *
					vec2(2.0, 200.0)
					+
					vec2(
						10.0,
						TIME *
						noise_speed
					)
				)
			);


		roll_line *=
			moving_noise *
			scanlines;


		roll_line *= clamp(
			random(
				ceil(
					uv * resolution
				)
				/ resolution
				+
				vec2(
					TIME * 0.8,
					0.0
				)
			).x + 0.8,
			0.0,
			1.0
		);


		text.rgb =
			clamp(
				mix(
					text.rgb,
					text.rgb + roll_line,
					noise_opacity
				),
				vec3(0.0),
				vec3(1.0)
			);
	}


	// ========================================================
	// STATIC NOISE
	// ========================================================

	if (static_noise_intensity > 0.0)
	{
		text.rgb +=
			clamp(
				random(
					ceil(
						uv * resolution
					)
					/ resolution
					+
					fract(TIME)
				).x,
				0.0,
				1.0
			)
			*
			static_noise_intensity;
	}


	// ========================================================
	// BORDER + VIGNETTE
	// ========================================================

	text.rgb *= border(uv);

	text.rgb *= vignette(uv);


	// ========================================================
	// CLIP WARP
	// ========================================================

	if (clip_warp)
	{
		text.a = border(uv);
	}


	// ========================================================
	// DISCOLORATION
	// ========================================================

	if (discolor)
	{
		float saturation = 0.5;
		float contrast = 1.2;


		vec3 greyscale =
			vec3(
				text.r +
				text.g +
				text.b
			) / 3.0;


		text.rgb =
			mix(
				text.rgb,
				greyscale,
				saturation
			);


		float midpoint =
			pow(0.5, 2.2);


		text.rgb =
			(
				text.rgb -
				vec3(midpoint)
			)
			*
			contrast
			+
			midpoint;
	}


	// ========================================================
	// OUTPUT
	// ========================================================

	COLOR = text;
}