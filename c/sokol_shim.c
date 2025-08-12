// c/sokol_shim.c
#define SOKOL_IMPL
#define SOKOL_GLUE_IMPL
#define SOKOL_NO_ENTRY          // we'll call sapp_run() ourselves (no sokol_main hijack)
#define SOKOL_GLCORE          // Linux GL backend; use D3D11 or Metal elsewhere
#include "sokol/sokol_app.h"
#include "sokol/sokol_gfx.h"
#include "sokol/sokol_glue.h"
#include "sokol/sokol_log.h"

#include <lean/lean.h>

static sg_pass_action g_pass;

// basic init/frame/cleanup
static void init(void) {
    sg_setup(&(sg_desc){ .environment = sglue_environment(), .logger.func = slog_func });
    g_pass = (sg_pass_action){
        .colors[0] = { .load_action = SG_LOADACTION_CLEAR,
                       .clear_value = {0.1f, 0.2f, 0.3f, 1.0f} }
    };
}
static void frame(void) {
    sg_begin_pass(&(sg_pass){ .action = g_pass, .swapchain = sglue_swapchain() });
    sg_end_pass();
    sg_commit();
}
static void cleanup(void) {
    sg_shutdown();
}

// ---- Lean externs ----

LEAN_EXPORT lean_obj_res lean_set_clear_color(double r, double g, double b, double a, lean_obj_arg /*w*/) {
    g_pass.colors[0].clear_value = (sg_color){ (float)r,(float)g,(float)b,(float)a };
    return lean_io_result_mk_ok(lean_box(0));
}

LEAN_EXPORT lean_obj_res lean_sapp_request_quit(lean_obj_arg /*w*/) {
    sapp_request_quit();
    return lean_io_result_mk_ok(lean_box(0));
}

LEAN_EXPORT lean_obj_res lean_sapp_run(lean_obj_arg /*w*/) {
    sapp_run(&(sapp_desc){
        .init_cb      = init,
        .frame_cb     = frame,
        .cleanup_cb   = cleanup,
        .width        = 640,
        .height       = 480,
        .window_title = "Sokol + Lean",
        .logger.func  = slog_func,
    });
    return lean_io_result_mk_ok(lean_box(0));
}
