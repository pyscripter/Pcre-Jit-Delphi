# Pcre-Jit-Delphi

Delphi wraps the [PCRE](https://www.pcre.org/) library into the System.RegularExpressions unit.  This unit provides a high-level easy-to-use interface to PCRE. 
A limitation however is that it does not provide access to the Just-In-Time (JIT) compiler of PCRE.  PCRE JIT can improve the performance of regular expression matching 
dramatically and is particularly useful, when you apply the same regular expression repetitively. The purpose of this project is to patch the Delphi RTL in
order to provide access to JIT.

## Instructions for using Pcre-Jit-Delphi

1. You first need to create the patched System.RegularExpressionsAPI.pas file in the Source directory (it is not in the repository due to licensing restrictions).  
The PowerShell script PatchRegularExpressionsAPI.ps1 does that. It copies the unit from the Delphi installation direcotry into the Source directory and then applies the patch "RegularExpressionsApi.diff" located in the same directory.  Git needs to be accessible from the command line for this to work.  The script assumes you have Delphi 10.4 installed.  If not, you can manually apply the patch by studying RegularExpressionsApi.diff,
which is relatively easy (small number of changes).
2. To use PCRE JIT in your delphi projects, you need to add the Source\System.RegularExpressionsAPI.pas to your project, so that it is used instead of he one provided by
Delphi.  You can then study the class helpers in the Benchmark.dpr console program (in the Demos directory) to see how you can use the PCRE JIT.  With the class helpers
all you need to do is call RegEx.StudyJIT before matching.

## Instructions for compiling PCRE from sources

The compiled object files that the patched System.RegularExpressionsAPI.pas needs are provided in the Source\obj folder.  To recreate these files from the PCRE sources you
need the following:

1. You need to have [Visual Studio](https://visualstudio.microsoft.com/) installed. [Community edition](https://visualstudio.microsoft.com/vs/community/) will do.
2. Execute the Powershell scripts CompilePCREx64 and CompilePCREx86 to recreate the Win64 and Win32 object files.


## Benchmark

The console project Benchmark.dpr in Demos folder compares the performance of the built-in Delphi regualar expressions library, with the those of using Study without JIT and 
Study with JIT on a commonly used regular expression benchmark.

Here are the results I got from the 64 bit version.

```
                                                        Time     | Match count
==============================================================================
Delphi's own TRegEx:
                                        /Twain/ :        7.00 ms |         811
                                    /(?i)Twain/ :       41.00 ms |         965
                                   /[a-z]shing/ :      384.00 ms |        1540
                   /Huck[a-zA-Z]+|Saw[a-zA-Z]+/ :      461.00 ms |         262
                                    /\b\w+nn\b/ :      588.00 ms |         262
                             /[a-q][^u-z]{13}x/ :      539.00 ms |        4094
                  /Tom|Sawyer|Huckleberry|Finn/ :      757.00 ms |        2598
              /(?i)Tom|Sawyer|Huckleberry|Finn/ :      861.00 ms |        4152
          /.{0,2}(Tom|Sawyer|Huckleberry|Finn)/ :     2615.00 ms |        2598
          /.{2,4}(Tom|Sawyer|Huckleberry|Finn)/ :     2766.00 ms |        1976
            /Tom.{10,25}river|river.{10,25}Tom/ :      455.00 ms |           2
                                 /[a-zA-Z]+ing/ :      807.00 ms |       78423
                        /\s[a-zA-Z]{0,12}ing\s/ :      560.00 ms |       49659
                /([A-Za-z]awyer|[A-Za-z]inn)\s/ :      789.00 ms |         209
                    /["'][^"']{0,30}[?!\.]["']/ :      321.00 ms |        8885
Total Time:    11963.00 ms
==============================================================================
Delphi's own TRegEx with Study:
                                        /Twain/ :        6.00 ms |         811
                                    /(?i)Twain/ :       41.00 ms |         965
                                   /[a-z]shing/ :      316.00 ms |        1540
                   /Huck[a-zA-Z]+|Saw[a-zA-Z]+/ :       21.00 ms |         262
                                    /\b\w+nn\b/ :      581.00 ms |         262
                             /[a-q][^u-z]{13}x/ :      413.00 ms |        4094
                  /Tom|Sawyer|Huckleberry|Finn/ :       28.00 ms |        2598
              /(?i)Tom|Sawyer|Huckleberry|Finn/ :      217.00 ms |        4152
          /.{0,2}(Tom|Sawyer|Huckleberry|Finn)/ :     2632.00 ms |        2598
          /.{2,4}(Tom|Sawyer|Huckleberry|Finn)/ :     2785.00 ms |        1976
            /Tom.{10,25}river|river.{10,25}Tom/ :       50.00 ms |           2
                                 /[a-zA-Z]+ing/ :      759.00 ms |       78423
                        /\s[a-zA-Z]{0,12}ing\s/ :      563.00 ms |       49659
                /([A-Za-z]awyer|[A-Za-z]inn)\s/ :      699.00 ms |         209
                    /["'][^"']{0,30}[?!\.]["']/ :       52.00 ms |        8885
Total Time:     9179.00 ms
==============================================================================
Delphi's own TRegEx with JIT:
                                        /Twain/ :       11.00 ms |         811
                                    /(?i)Twain/ :       14.00 ms |         965
                                   /[a-z]shing/ :       12.00 ms |        1540
                   /Huck[a-zA-Z]+|Saw[a-zA-Z]+/ :        3.00 ms |         262
                                    /\b\w+nn\b/ :      126.00 ms |         262
                             /[a-q][^u-z]{13}x/ :      154.00 ms |        4094
                  /Tom|Sawyer|Huckleberry|Finn/ :       22.00 ms |        2598
              /(?i)Tom|Sawyer|Huckleberry|Finn/ :       61.00 ms |        4152
          /.{0,2}(Tom|Sawyer|Huckleberry|Finn)/ :      277.00 ms |        2598
          /.{2,4}(Tom|Sawyer|Huckleberry|Finn)/ :      346.00 ms |        1976
            /Tom.{10,25}river|river.{10,25}Tom/ :       12.00 ms |           2
                                 /[a-zA-Z]+ing/ :       84.00 ms |       78423
                        /\s[a-zA-Z]{0,12}ing\s/ :      156.00 ms |       49659
                /([A-Za-z]awyer|[A-Za-z]inn)\s/ :       35.00 ms |         209
                    /["'][^"']{0,30}[?!\.]["']/ :       18.00 ms |        8885
Total Time:     1350.00 ms
```

As you can see the increase in performance is impressive.


