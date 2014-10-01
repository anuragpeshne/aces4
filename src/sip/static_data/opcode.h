/*
 * opcode.h

 This file was generated by edu.ufl.cise.sial.compiler.util.GenerateCPPOpcodes.java

20140821_122536

*
*/

#ifndef OPCODE_H_
#define OPCODE_H_

#include <string>
#include "sip.h"

namespace sip {
//codes for where clauses
enum where_code_t {
	where_eq = 0,
	where_geq = 1,
	where_leq = 2,
	where_gt = 3,
	where_lt = 4,
	where_neq = 5
};
/**opcodes and optable entry contents
 *
 * An optable entry contains the following fields
 * opcode, op0, op1, op2, selector[MAX_RANK], line_number
 *
* Below, the contents of the entry for each opcode is indicated
 * Unused slots are indicate with _
*
* X-Macros are used to define the opcodes as an enum and a enum-to-string function.
*
*/

#define SIP_OPCODES \
SIPOP(goto_op,100,"goto",true)\
SIPOP(jump_if_zero_op,101,"jump_if_zero",true)\
SIPOP(stop_op,102,"stop",true)\
SIPOP(call_op,103,"call",true)\
SIPOP(return_op,104,"return",true)\
SIPOP(execute_op,105,"execute",true)\
SIPOP(do_op,106,"do",true)\
SIPOP(enddo_op,107,"enddo",true)\
SIPOP(dosubindex_op,108,"dosubindex",true)\
SIPOP(enddosubindex_op,109,"enddosubindex",true)\
SIPOP(exit_op,110,"exit",true)\
SIPOP(where_op,111,"where",true)\
SIPOP(pardo_op,112,"pardo",true)\
SIPOP(endpardo_op,113,"endpardo",true)\
SIPOP(begin_pardo_section_op,114,"begin_pardo_section",true)\
SIPOP(end_pardo_section_op,115,"end_pardo_section",true)\
SIPOP(sip_barrier_op,116,"sip_barrier",true)\
SIPOP(broadcast_static_op,117,"broadcast_static",true)\
SIPOP(push_block_selector_op,118,"push_block_selector",true)\
SIPOP(allocate_op,119,"allocate",true)\
SIPOP(deallocate_op,120,"deallocate",true)\
SIPOP(allocate_contiguous_op,121,"allocate_contiguous",true)\
SIPOP(deallocate_contiguous_op,122,"deallocate_contiguous",true)\
SIPOP(get_op,123,"get",true)\
SIPOP(put_accumulate_op,124,"put_accumulate",true)\
SIPOP(put_replace_op,125,"put_replace",true)\
SIPOP(create_op,126,"create",true)\
SIPOP(delete_op,127,"delete",true)\
SIPOP(int_load_value_op,128,"int_load_value",true)\
SIPOP(int_load_literal_op,129,"int_load_literal",true)\
SIPOP(int_store_op,130,"int_store",true)\
SIPOP(index_load_value_op,131,"index_load_value",true)\
SIPOP(int_add_op,132,"int_add",true)\
SIPOP(int_subtract_op,133,"int_subtract",true)\
SIPOP(int_multiply_op,134,"int_multiply",true)\
SIPOP(int_divide_op,135,"int_divide",true)\
SIPOP(int_equal_op,136,"int_equal",true)\
SIPOP(int_nequal_op,137,"int_nequal",true)\
SIPOP(int_ge_op,138,"int_ge",true)\
SIPOP(int_le_op,139,"int_le",true)\
SIPOP(int_gt_op,140,"int_gt",true)\
SIPOP(int_lt_op,141,"int_lt",true)\
SIPOP(int_neg_op,142,"int_neg",true)\
SIPOP(cast_to_int_op,143,"cast_to_int",true)\
SIPOP(scalar_load_value_op,144,"scalar_load_value",true)\
SIPOP(scalar_store_op,145,"scalar_store",true)\
SIPOP(scalar_add_op,146,"scalar_add",true)\
SIPOP(scalar_subtract_op,147,"scalar_subtract",true)\
SIPOP(scalar_multiply_op,148,"scalar_multiply",true)\
SIPOP(scalar_divide_op,149,"scalar_divide",true)\
SIPOP(scalar_exp_op,150,"scalar_exp",true)\
SIPOP(scalar_eq_op,151,"scalar_eq",true)\
SIPOP(scalar_ne_op,152,"scalar_ne",true)\
SIPOP(scalar_ge_op,153,"scalar_ge",true)\
SIPOP(scalar_le_op,154,"scalar_le",true)\
SIPOP(scalar_gt_op,155,"scalar_gt",true)\
SIPOP(scalar_lt_op,156,"scalar_lt",true)\
SIPOP(scalar_neg_op,157,"scalar_neg",true)\
SIPOP(scalar_sqrt_op,158,"scalar_sqrt",true)\
SIPOP(cast_to_scalar_op,159,"cast_to_scalar",true)\
SIPOP(collective_sum_op,160,"collective_sum",true)\
SIPOP(assert_same_op,161,"assert_same",true)\
SIPOP(tensor_op,162,"tensor",true)\
SIPOP(block_copy_op,163,"block_copy",true)\
SIPOP(block_permute_op,164,"block_permute",true)\
SIPOP(block_fill_op,165,"block_fill",true)\
SIPOP(block_scale_op,166,"block_scale",true)\
SIPOP(block_scale_assign_op,167,"block_scale_assign",true)\
SIPOP(block_scale_accumulate_op,168,"block_scale_accumulate",true)\
SIPOP(block_accumulate_scalar_op,169,"block_accumulate_scalar",true)\
SIPOP(block_add_op,170,"block_add",true)\
SIPOP(block_subtract_op,171,"block_subtract",true)\
SIPOP(block_contract_op,172,"block_contract",true)\
SIPOP(block_contract_accumulate_op,173,"block_contract_accumulate",true)\
SIPOP(block_contract_to_scalar_op,174,"block_contract_to_scalar",true)\
SIPOP(block_load_scalar_op,175,"block_load_scalar",true)\
SIPOP(slice_op,176,"slice",true)\
SIPOP(insert_op,177,"insert",true)\
SIPOP(string_load_literal_op,178,"string_load_literal",true)\
SIPOP(print_string_op,179,"print_string",true)\
SIPOP(println_op,180,"println",true)\
SIPOP(print_index_op,181,"print_index",true)\
SIPOP(print_scalar_op,182,"print_scalar",true)\
SIPOP(print_int_op,183,"print_int",true)\
SIPOP(print_block_op,184,"print_block",true)\
SIPOP(gpu_on_op,185,"gpu_on",true)\
SIPOP(gpu_off_op,186,"gpu_off",true)\
SIPOP(gpu_allocate_op,187,"gpu_allocate",true)\
SIPOP(gpu_free_op,188,"gpu_free",true)\
SIPOP(gpu_put_op,189,"gpu_put",true)\
SIPOP(gpu_get_op,190,"gpu_get",true)\
SIPOP(gpu_get_int_op,191,"gpu_get_int",true)\
SIPOP(gpu_put_int_op,192,"gpu_put_int",true)\
SIPOP(set_persistent_op,193,"set_persistent",true)\
SIPOP(restore_persistent_op,194,"restore_persistent",true)\
SIPOP(idup_op,195,"idup",true)\
SIPOP(iswap_op,196,"iswap",true)\
SIPOP(sswap_op,197,"sswap",true)\
SIPOP(invalid_op,198,"invalid",false)\

enum opcode_t {
#define SIPOP(e,n,t,p) e = n,
	SIP_OPCODES
#undef SIPOP
	last_op
};

/**
 * Converts an opcode to it's string equivalent
 * @param
 * @return
 */
std::string opcodeToName(opcode_t);
/**
 * Converts an integer to an opcode
 * @param
 * @return
 */
opcode_t intToOpcode(int);
/**
 * Whether a certain opcode is printable
 * @param
 * @return
 */
bool printableOpcode(opcode_t);

} /* namespace sip */
#endif /* OPCODE_H_ */
