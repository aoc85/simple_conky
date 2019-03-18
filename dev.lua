require 'cairo'

function conky_main()
    if conky_window == nil then
        print("setting up")
        return
    end
    local cs = cairo_xlib_surface_create(conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)
    cr = cairo_create(cs)
    local updates = tonumber (conky_parse ('${updates}'))
    if updates > 5 then
        conky_draw_text (conky_parse ('${time %d/%m/%Y}'), 65, 100, 15, 0.9, 0.6, 0.4 )
        conky_draw_text (conky_parse ('${time %H:%M}'), 80, 125, 16, 0.9, 0.6, 0.4)  
        conky_draw_text ("CPU: " .. conky_parse ('${cpu}') .. '%', 2, 13, 13, 1, 1, 1)
        conky_draw_text ("Memory: " .. conky_parse ('${memperc}') .. '%', 2, 35, 13, 1, 1, 1)
        conky_draw_cpu_arc(0.6, 0.6, 1, 0.3, 360)
        local cpu_instant = parse_percentage_to_draw (conky_parse ('${cpu}'))
        conky_draw_cpu_arc(0.4, 0.4, 1, 1, cpu_instant )
        local memo_instant = parse_percentage_to_draw (conky_parse ('${memperc}')) 
        conky_draw_memo_arc (0.6, 0.6, 1, 0.3, 360)
        conky_draw_memo_arc (0.4, 0.4, 1, 1, memo_instant) 
    end
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end

function parse_percentage_to_draw (value)
    return  90 + tonumber (value) * 2.7
end

function conky_draw_text (text, x, y, size, r , g, b)
    font = "adobe-source-code-pro"
    font_size = size
    xpos = x
    ypos = y
    text = text
    red, green, blue, alpha = r, g, b, 1
    font_slant = CAIRO_FONT_SLANT_NORMAL
    font_face = CAIRO_FONT_WEIGHT_BOLD
    ----------------------------------
    cairo_select_font_face (cr, font, font_slant, font_face);
    cairo_set_font_size (cr, font_size)
    cairo_set_source_rgba (cr, red, green, blue, alpha)
    cairo_move_to (cr, xpos, ypos)
    cairo_show_text (cr, text)
    cairo_stroke (cr)
end

function conky_draw_cpu_arc (r, g, b, a, arc_end)
    cairo_set_line_width (cr, 8)
    local red, green, blue, alpha = r, g, b, a
    cairo_set_source_rgba (cr, red, green, blue, alpha)
    center_y = 100
    center_x = 100
    radius = 90
    start_angle = 90
    end_angle = arc_end
    cairo_arc (cr, center_x, center_y, radius, (start_angle-180) * (math.pi/180), (end_angle-180) * (math.pi/180))
    cairo_stroke (cr)
end

function conky_draw_memo_arc(r, g, b, a, arc_end)
    cairo_set_line_width(cr, 7)
    local red, green, blue,  alpha = r, g, b, a
    cairo_set_source_rgba (cr, red, green, blue, alpha)
    center_y = 100
    center_x = 100
    radius = 70
    start_angle = 90
    end_angle = arc_end
    cairo_arc (cr, center_x, center_y, radius, (start_angle-180) * (math.pi/180), (end_angle-180) * (math.pi/180)) 
    cairo_stroke (cr)
end
