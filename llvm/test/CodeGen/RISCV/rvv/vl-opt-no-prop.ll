; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 -mattr=+v -verify-machineinstrs \
; RUN:   | FileCheck %s
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 -mattr=+v -verify-machineinstrs \
; RUN:   | FileCheck %s
; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 -mattr=+v -riscv-enable-vl-optimizer \
; RUN:   -verify-machineinstrs | FileCheck %s
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 -mattr=+v -riscv-enable-vl-optimizer \
; RUN:   -verify-machineinstrs | FileCheck %s

declare <vscale x 4 x i32> @llvm.riscv.vadd.nxv4i32.nxv4i32(<vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32>, iXLen)
declare <vscale x 4 x i32> @llvm.riscv.vrgather.vv.nxv4i32.iXLen(
  <vscale x 4 x i32>,
  <vscale x 4 x i32>,
  <vscale x 4 x i32>,
  iXLen)

declare <vscale x 4 x i32> @llvm.riscv.vslidedown.nxv4i32(
  <vscale x 4 x i32>,
  <vscale x 4 x i32>,
  iXLen,
  iXLen,
  iXLen);

declare <vscale x 4 x i32> @llvm.riscv.vslide1down.nxv4i32.i32(
  <vscale x 4 x i32>,
  <vscale x 4 x i32>,
  i32,
  iXLen);

define <vscale x 4 x i32> @vrgather(<vscale x 4 x i32> %passthru, <vscale x 4 x i32> %a, <vscale x 4 x i32> %b, iXLen %vl1, iXLen %vl2) {
; CHECK-LABEL: vrgather:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m2, ta, ma
; CHECK-NEXT:    vadd.vv v12, v10, v12
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, ma
; CHECK-NEXT:    vrgather.vv v8, v12, v10
; CHECK-NEXT:    ret
  %v = add <vscale x 4 x i32> %a, %b
  %w = call <vscale x 4 x i32> @llvm.riscv.vrgather.vv.nxv4i32.iXLen(
    <vscale x 4 x i32> poison,
    <vscale x 4 x i32> %v,
    <vscale x 4 x i32> %a,
    iXLen %vl1)

  ret <vscale x 4 x i32> %w
}

define <vscale x 4 x i32> @vslidedown(<vscale x 4 x i32> %0, <vscale x 4 x i32> %1, iXLen %2, <vscale x 4 x i32> %a, <vscale x 4 x i32> %b) nounwind {
; CHECK-LABEL: vslidedown:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, zero, e32, m2, ta, ma
; CHECK-NEXT:    vadd.vv v10, v12, v14
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v10, a0
; CHECK-NEXT:    ret
entry:
  %v = add <vscale x 4 x i32> %a, %b
  %w = call <vscale x 4 x i32> @llvm.riscv.vslidedown.nxv4i32(
    <vscale x 4 x i32> %0,
    <vscale x 4 x i32> %v,
    iXLen %2,
    iXLen %2,
    iXLen 1)

  ret <vscale x 4 x i32> %w
}

define <vscale x 4 x i32> @vslide1down(<vscale x 4 x i32> %0, i32 %1, iXLen %2, <vscale x 4 x i32> %a, <vscale x 4 x i32> %b) nounwind {
; CHECK-LABEL: vslide1down:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a2, zero, e32, m2, ta, ma
; CHECK-NEXT:    vadd.vv v8, v10, v12
; CHECK-NEXT:    vsetvli zero, a1, e32, m2, ta, ma
; CHECK-NEXT:    vslide1down.vx v8, v8, a0
; CHECK-NEXT:    ret
entry:
  %v = add <vscale x 4 x i32> %a, %b
  %w = call <vscale x 4 x i32> @llvm.riscv.vslide1down.nxv4i32.i32(
    <vscale x 4 x i32> poison,
    <vscale x 4 x i32> %v,
    i32 %1,
    iXLen %2)

  ret <vscale x 4 x i32> %w
}
