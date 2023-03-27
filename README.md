# PCM Code Compressor
 A 12-to-8 bit digital compressor for PCM code


| Segment # | 12-bit Linear Code | 8-bit Compressed Code |
|-----------|--------------------|-----------------------|
|         0 | S000 0000 ABCD     | S000 ABCD             |
|         1 | S000 0001 ABCD     | S001 ABCD             |
|         2 | S000 001A BCDX     | S010 ABCD             |
|         3 | S000 01AB CDXX     | S011 ABCD             |
|         4 | S000 1ABC DXXX     | S100 ABCD             |
|         5 | S001 ABCD XXXX     | S101 ABCD             |
|         6 | S01A BCDX XXXX     | S110 ABCD             |
|         7 | S1AB CDXX XXXX     | S111 ABCD             |

Each code represents a signal level in a sign-magnitude format where S is the sign bit, and the rest of the bits represent the magnitude. The digital compressor accepts a 12-bit input linear PCM code and then returns an 8-bit compressed code. Note that A, B, C, and D bits are the higher order bits to be preserved in the output compressed code, while the X’s represent the lower order bits from the input that are discarded. Note further in the 8-bit compressed code that the 3 bits after the sign bit S represent the segment number. Basically, the compression process breaks the dynamic range into 8 segments, as shown in the table.

----Instruction---

Write a working x86-32 assembly program that accepts a 12-bit linear PCM code as input and then returns the equivalent 8-bit compressed code.

Input: Prompt user for input. Input should be a string. 

Error checking: Check for two types of invalid inputs. If an error exists, output an appropriate error message. Specifically, the type 1 error is an invalid character (i.e., neither ‘1’ nor ‘0’), and the type 2 error is an invalid input length (i.e., not 12 bits).

Process: Given an input 12-bit code, determine and print the 8-bit compressed code in a new line. Prompt the user whether the program will be executed again. Otherwise, terminate the program.

Outputs: 8-bit compressed code, segment number, and the error message (if any). Prompt the user whether the program will be executed again.

See the example input/output dialog below.

```
Input 12-bit code: 11111
Error: Input should be 12 bits in length!
Do you want to continue (Y/N)? Y

Input 12-bit code: 111111111111111111111111
Error: Input should be 12 bits in length!
Do you want to continue (Y/N)? Y

Input 12-bit code: 1111ABCDFFFF
Error: Input should be 1’s and 0’s only!
Do you want to continue (Y/N)? Y

Input 12-bit code: 1111ABCD
Error: Input should be 1’s and 0’s only!
Error: Input should be 12 bits in length!
Do you want to continue (Y/N)? Y

Input 12-bit code: 100000000111
Compressed code: 10000111
Segment number: 0
Do you want to continue (Y/N)? Y

Input 12-bit code: 100001010111
Compressed code: 10110101
Segment number: 3
Do you want to continue (Y/N)? Y

Input 12-bit code: 010001111111
Compressed code: 01110001
Segment number: 7
Do you want to continue (Y/N)? N

--Program Terminated--
```
