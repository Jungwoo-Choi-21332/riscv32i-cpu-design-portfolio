.section    .start
.global     _start

_start:
init:
    la s0, byte
    addi s1, zero, 20            # s1 = 20
    jalr s2, 0(s1)               # s2 = next_pc = 16, jump s1_value = 20
    addi s1, s1, 20              # shouldn't execute
    lui s3, 3                    # s3 = 12288
    lui s4, 7                    # s4 = 28672
    addi s3, s3, 20              # s3 = 12308
    addi s4, s4, 7               # s4 = 28679
    addi s5, zero, 1             # s5 = 1
    sra s4, s4, s5               # s4 = 28679/2 = 14339
    sb s3, 4(s0)                 # [24] = 0x14
    sw s4, 8(s0)                 # [28] = 14339
    lw s5, 4(s0)                 # s5 = 0x14
    lbu s6, 8(s0)                # s6 = 0x03  
    blt s6, s5, less_than        # s6 < s5 ... jump to less_then
	addi s5, s5, 1               # shouldn't execute   

less_than:
    slli s7, s6, 2               # s7 = 12
    srai s8, s5, 1               # s8 = 10
    bge s7, s8, greater          # s7 >= s8 ... jump to greater
    j end                        # shouldn't execute   

greater:
    addi s8, s8, 2               # s8 = 12
    bltu s7, s8, sub_result      # s7 == s8 ... no jump
    bgeu s7, s8, add_result      # s7 >= s8 ... jump to add_result    

sub_result:
    sub s9, s8, s7 		   # shouldn't execute   

add_result:
    add s9, s8, s7		   # s9 = s8 + s7 = 12 + 12 = 24

end:
    sw s9, 12(s0)                 # [32] = 24
    j end

.data
 byte: .byte 0, 0
