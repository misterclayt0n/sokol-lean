#include <lean/lean.h>
#include <stdlib.h>
#include <stdint.h>

typedef struct {
  uint64_t sum;
  uint32_t count;
} Acc;

static lean_external_class * g_AccClass = NULL;

static void acc_finalize(void *p) { free((Acc*)p); }
static void acc_foreach(void * /*p*/, b_lean_obj_arg /*fn*/) { /* No references inside Acc. */ }

static inline lean_object * box_acc(Acc *p) {
  return lean_alloc_external(g_AccClass, p);
}

static inline Acc * unbox_acc(lean_object *o) {
  return (Acc*)lean_get_external_data(o);
}

// One time registration from the external class (call from Lean once).
LEAN_EXPORT lean_obj_res lean_acc_init(lean_obj_arg /*w*/) {
  if (!g_AccClass) {
    g_AccClass = lean_register_external_class(acc_finalize, acc_foreach);
  }
  
  return lean_io_result_mk_ok(lean_box(0));
}

LEAN_EXPORT lean_obj_res lean_acc_new(lean_obj_arg /*w*/) {
  Acc *p = (Acc*)malloc(sizeof(Acc));
  if (!p) {
    return lean_io_result_mk_error(lean_mk_string("alloc failed"));
  }
  p->sum = 0;
  p->count = 0;

  return lean_io_result_mk_ok(box_acc(p));
}

LEAN_EXPORT lean_obj_arg lean_acc_add(b_lean_obj_arg a, uint32_t x, lean_obj_arg /*w*/) {
  Acc *p = unbox_acc(a);
  p->sum += x;
  p->count += 1;
  return lean_io_result_mk_ok(lean_box(0));
}

LEAN_EXPORT lean_obj_res lean_acc_mean(b_lean_obj_arg a, lean_obj_arg /*w*/) {
  Acc *p = unbox_acc(a);
  double m = (p->count == 0) ? 0.0 : ((double)p->sum / (double)p->count);
  return lean_io_result_mk_ok(lean_box_float(m));
}

LEAN_EXPORT lean_obj_res lean_acc_free(lean_obj_arg a, lean_obj_arg /*w*/) {
  Acc *p = unbox_acc(a);
  if (p) {
    free(p);
  }
  lean_set_external_data(a, NULL);
  return lean_io_result_mk_ok(lean_box(0));
}
