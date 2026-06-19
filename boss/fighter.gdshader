shader_type canvas_item;

// Esto te crea un selector de color en el Inspector
uniform vec4 color_fondo : source_color;
// Tolerancia por si el celeste tiene variaciones
uniform float tolerancia = 0.1;

void fragment() {
    vec4 color_actual = texture(TEXTURE, UV);
    // Si el color del pixel es muy parecido al color de fondo, lo hacemos invisible (alpha 0)
    if (distance(color_actual.rgb, color_fondo.rgb) < tolerancia) {
        color_actual.a = 0.0;
    }
    COLOR = color_actual;
}