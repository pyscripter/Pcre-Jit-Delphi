{******************************************************************************}
{                                                                              }
{                    CodeGear Delphi Runtime Library                           }
{                                                                              }
{             Copyright(c) 1995-2020 Embarcadero Technologies, Inc.            }
{              All rights reserved                                             }
{                                                                              }
{                      Header conversion of pcre.h                             }
{                                                                              }
{                Translator: Embarcadero Technologies, Inc.                    }
{                                                                              }
{                   Based on original translations by:                         }
{                                                                              }
{                            Florent Ouchet                                    }
{                            Mario R. Carro                                    }
{                            Robert Rossmair                                   }
{                            Peter Thornqvist                                  }
{                            Jan Goyvaerts                                     }
{                                                                              }
{******************************************************************************}

{******************************************************************************}
{                                                                              }
{ PCRE LICENCE                                                                 }
{ ------------                                                                 }
{                                                                              }
{ PCRE is a library of functions to support regular expressions whose syntax   }
{ and semantics are as close as possible to those of the Perl 5 language.      }
{                                                                              }
{ Release 8 of PCRE is distributed under the terms of the "BSD" licence, as    }
{ specified below. The documentation for PCRE, supplied in the "doc"           }
{ directory, is distributed under the same terms as the software itself.       }
{                                                                              }
{ The basic library functions are written in C and are freestanding. Also      }
{ included in the distribution is a set of C++ wrapper functions, and a        }
{ just-in-time compiler that can be used to optimize pattern matching. These   }
{ are both optional features that can be omitted when the library is built.    }
{                                                                              }
{                                                                              }
{ THE BASIC LIBRARY FUNCTIONS                                                  }
{ ---------------------------                                                  }
{                                                                              }
{ Written by:       Philip Hazel                                               }
{ Email local part: ph10                                                       }
{ Email domain:     cam.ac.uk                                                  }
{                                                                              }
{ University of Cambridge Computing Service,                                   }
{ Cambridge, England.                                                          }
{                                                                              }
{ Copyright (c) 1997-2014 University of Cambridge                              }
{ All rights reserved.                                                         }
{                                                                              }
{                                                                              }
{ PCRE JUST-IN-TIME COMPILATION SUPPORT                                        }
{ -------------------------------------                                        }
{                                                                              }
{ Written by:       Zoltan Herczeg                                             }
{ Email local part: hzmester                                                   }
{ Emain domain:     freemail.hu                                                }
{                                                                              }
{ Copyright(c) 2010-2014 Zoltan Herczeg                                        }
{ All rights reserved.                                                         }
{                                                                              }
{                                                                              }
{ STACK-LESS JUST-IN-TIME COMPILER                                             }
{ --------------------------------                                             }
{                                                                              }
{ Written by:       Zoltan Herczeg                                             }
{ Email local part: hzmester                                                   }
{ Emain domain:     freemail.hu                                                }
{                                                                              }
{ Copyright(c) 2009-2014 Zoltan Herczeg                                        }
{ All rights reserved.                                                         }
{                                                                              }
{                                                                              }
{ THE C++ WRAPPER FUNCTIONS                                                    }
{ -------------------------                                                    }
{                                                                              }
{ Contributed by:   Google Inc.                                                }
{                                                                              }
{ Copyright (c) 2007-2012, Google Inc.                                         }
{ All rights reserved.                                                         }
{                                                                              }
{                                                                              }
{ THE "BSD" LICENCE                                                            }
{ -----------------                                                            }
{                                                                              }
{ Redistribution and use in source and binary forms, with or without           }
{ modification, are permitted provided that the following conditions are met:  }
{                                                                              }
{    * Redistributions of source code must retain the above copyright notice,  }
{      this list of conditions and the following disclaimer.                   }
{                                                                              }
{    * Redistributions in binary form must reproduce the above copyright       }
{      notice, this list of conditions and the following disclaimer in the     }
{      documentation and/or other materials provided with the distribution.    }
{                                                                              }
{    * Neither the name of the University of Cambridge nor the name of Google  }
{      Inc. nor the names of their contributors may be used to endorse or      }
{      promote products derived from this software without specific prior      }
{      written permission.                                                     }
{                                                                              }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"  }
{ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE    }
{ IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE   }
{ ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE     }
{ LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR          }
{ CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF         }
{ SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS     }
{ INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN      }
{ CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)      }
{ ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE   }
{ POSSIBILITY OF SUCH DAMAGE.                                                  }
{                                                                              }
{ End                                                                          }
{                                                                              }
{******************************************************************************}

unit System.RegularExpressionsAPI;

interface

(*************************************************
*       Perl-Compatible Regular Expressions      *
*************************************************)

{$IFDEF MSWINDOWS}{$DEFINE PCRE16}{$ENDIF}
{$WEAKPACKAGEUNIT ON}

const
  MAX_PATTERN_LENGTH = $10003;
  MAX_QUANTIFY_REPEAT = $10000;
  MAX_CAPTURE_COUNT = $FFFF;
  MAX_NESTING_DEPTH = 200;

const
  (* Options *)
  PCRE_CASELESS = $00000001;
  PCRE_MULTILINE = $00000002;
  PCRE_DOTALL = $00000004;
  PCRE_EXTENDED = $00000008;
  PCRE_ANCHORED = $00000010;
  PCRE_DOLLAR_ENDONLY = $00000020;
  PCRE_EXTRA = $00000040;
  PCRE_NOTBOL = $00000080;
  PCRE_NOTEOL = $00000100;
  PCRE_UNGREEDY = $00000200;
  PCRE_NOTEMPTY = $00000400;
  PCRE_UTF8 = $00000800;
  PCRE_UTF16 = $00000800;
  PCRE_UTF32 = $00000800;
  PCRE_NO_AUTO_CAPTURE = $00001000;
  PCRE_NO_UTF8_CHECK = $00002000;
  PCRE_NO_UTF16_CHECK = $00002000;
  PCRE_NO_UTF32_CHECK = $00002000;
  PCRE_AUTO_CALLOUT = $00004000;
  PCRE_PARTIAL = $00008000;
  PCRE_NEVER_UTF = $00010000;
  PCRE_DFA_SHORTEST = $00010000;
  PCRE_NO_AUTO_POSSESS = $00020000;
  PCRE_DFA_RESTART = $00020000;
  PCRE_FIRSTLINE = $00040000;
  PCRE_DUPNAMES = $00080000;
  PCRE_NEWLINE_CR = $00100000;
  PCRE_NEWLINE_LF = $00200000;
  PCRE_NEWLINE_CRLF = $00300000;
  PCRE_NEWLINE_ANY = $00400000;
  PCRE_NEWLINE_ANYCRLF = $00500000;
  PCRE_BSR_ANYCRLF = $00800000;
  PCRE_BSR_UNICODE = $01000000;
  PCRE_JAVASCRIPT_COMPAT = $02000000;
  PCRE_NO_START_OPTIMIZE = $04000000;
  PCRE_NO_START_OPTIMISE = $04000000;
  PCRE_PARTIAL_HARD = $08000000;
  PCRE_NOTEMPTY_ATSTART = $10000000;
  PCRE_UCP = $20000000;

  (* Exec-time and get-time error codes *)

  PCRE_ERROR_NOMATCH = -1;
  PCRE_ERROR_NULL = -2;
  PCRE_ERROR_BADOPTION = -3;
  PCRE_ERROR_BADMAGIC = -4;
  PCRE_ERROR_UNKNOWN_NODE = -5;
  PCRE_ERROR_NOMEMORY = -6;
  PCRE_ERROR_NOSUBSTRING = -7;
  PCRE_ERROR_MATCHLIMIT = -8;
  PCRE_ERROR_CALLOUT = -9;  (* Never used by PCRE itself *)
  PCRE_ERROR_BADUTF8 = -10;
  PCRE_ERROR_BADUTF16 = -10;
  PCRE_ERROR_BADUTF32 = -10;
  PCRE_ERROR_BADUTF8_OFFSET = -11;
  PCRE_ERROR_BADUTF16_OFFSET = -11;
  PCRE_ERROR_PARTIAL = -12;
  PCRE_ERROR_BADPARTIAL = -13;
  PCRE_ERROR_INTERNAL = -14;
  PCRE_ERROR_BADCOUNT = -15;
  PCRE_ERROR_DFA_UITEM = -16;
  PCRE_ERROR_DFA_UCOND = -17;
  PCRE_ERROR_DFA_UMLIMIT = -18;
  PCRE_ERROR_DFA_WSSIZE = -19;
  PCRE_ERROR_DFA_RECURSE = -20;
  PCRE_ERROR_RECURSIONLIMIT = -21;
  PCRE_ERROR_NULLWSLIMIT = -22;  (* No longer actually used *)
  PCRE_ERROR_BADNEWLINE = -23;
  PCRE_ERROR_BADOFFSET = -24;
  PCRE_ERROR_SHORTUTF8 = -25;
  PCRE_ERROR_SHORTUTF16 = -25;  (*Same for 8/16 *)
  PCRE_ERROR_RECURSELOOP = -26;
  PCRE_ERROR_JIT_STACKLIMIT = -27;
  PCRE_ERROR_BADMODE = -28;
  PCRE_ERROR_BADENDIANNESS = -29;
  PCRE_ERROR_DFA_BADRESTART = -30;
  PCRE_ERROR_JIT_BADOPTION = -31;
  PCRE_ERROR_BADLENGTH = -32;
  PCRE_ERROR_UNSET = -33;

(* Specific error codes for UTF-8 validity checks *)

  PCRE_UTF8_ERR0 = 0;
  PCRE_UTF8_ERR1 = 1;
  PCRE_UTF8_ERR2 = 2;
  PCRE_UTF8_ERR3 = 3;
  PCRE_UTF8_ERR4 = 4;
  PCRE_UTF8_ERR5 = 5;
  PCRE_UTF8_ERR6 = 6;
  PCRE_UTF8_ERR7 = 7;
  PCRE_UTF8_ERR8 = 8;
  PCRE_UTF8_ERR9 = 9;
  PCRE_UTF8_ERR10 = 10;
  PCRE_UTF8_ERR11 = 11;
  PCRE_UTF8_ERR12 = 12;
  PCRE_UTF8_ERR13 = 13;
  PCRE_UTF8_ERR14 = 14;
  PCRE_UTF8_ERR15 = 15;
  PCRE_UTF8_ERR16 = 16;
  PCRE_UTF8_ERR17 = 17;
  PCRE_UTF8_ERR18 = 18;
  PCRE_UTF8_ERR19 = 19;
  PCRE_UTF8_ERR20 = 20;
  PCRE_UTF8_ERR21 = 21;
  PCRE_UTF8_ERR22 = 22;  (* Unused (was non-character) *)

  (* Specific error codes for UTF-16 validity checks *)

  PCRE_UTF16_ERR0 = 0;
  PCRE_UTF16_ERR1 = 1;
  PCRE_UTF16_ERR2 = 2;
  PCRE_UTF16_ERR3 = 3;
  PCRE_UTF16_ERR4 = 4;  (* Unused (was non-character) *)

  (* Specific error codes for UTF-32 validity checks *)

  PCRE_UTF32_ERR0 = 0;
  PCRE_UTF32_ERR1 = 1;
  PCRE_UTF32_ERR2 = 2;  (* Unused (was non-character) *)
  PCRE_UTF32_ERR3 = 3;

  (* Request types for pcre_fullinfo() *)

  PCRE_INFO_OPTIONS = 0;
  PCRE_INFO_SIZE = 1;
  PCRE_INFO_CAPTURECOUNT = 2;
  PCRE_INFO_BACKREFMAX = 3;
  PCRE_INFO_FIRSTCHAR = 4;
  PCRE_INFO_FIRSTTABLE = 5;
  PCRE_INFO_LASTLITERAL = 6;
  PCRE_INFO_NAMEENTRYSIZE = 7;
  PCRE_INFO_NAMECOUNT = 8;
  PCRE_INFO_NAMETABLE = 9;
  PCRE_INFO_STUDYSIZE = 10;
  PCRE_INFO_DEFAULT_TABLES = 11;
  PCRE_INFO_OKPARTIAL = 12;
  PCRE_INFO_JCHANGED = 13;
  PCRE_INFO_HASCRORLF = 14;
  PCRE_INFO_MINLENGTH = 15;
  PCRE_INFO_JIT = 16;
  PCRE_INFO_JITSIZE = 17;
  PCRE_INFO_MAXLOOKBEHIND = 18;
  PCRE_INFO_FIRSTCHARACTER = 19;
  PCRE_INFO_FIRSTCHARACTERFLAGS = 20;
  PCRE_INFO_REQUIREDCHAR = 21;
  PCRE_INFO_REQUIREDCHARFLAGS = 22;
  PCRE_INFO_MATCHLIMIT = 23;
  PCRE_INFO_RECURSIONLIMIT = 24;
  PCRE_INFO_MATCH_EMPTY = 25;

  (* Request types for pcre_config(). Do not re-arrange, in order to remain
     compatible. *)
  PCRE_CONFIG_UTF8 = 0;
  PCRE_CONFIG_NEWLINE = 1;
  PCRE_CONFIG_LINK_SIZE = 2;
  PCRE_CONFIG_POSIX_MALLOC_THRESHOLD = 3;
  PCRE_CONFIG_MATCH_LIMIT = 4;
  PCRE_CONFIG_STACKRECURSE = 5;
  PCRE_CONFIG_UNICODE_PROPERTIES = 6;
  PCRE_CONFIG_MATCH_LIMIT_RECURSION = 7;
  PCRE_CONFIG_BSR = 8;
  PCRE_CONFIG_JIT = 9;
  PCRE_CONFIG_UTF16 = 10;
  PCRE_CONFIG_JITTARGET = 11;
  PCRE_CONFIG_UTF32 = 12;
  PCRE_CONFIG_PARENS_LIMIT = 13;

  (* Request types for pcre_study(). Do not re-arrange, in order to remain
     compatible. *)

  PCRE_STUDY_JIT_COMPILE = $0001;
  PCRE_STUDY_JIT_PARTIAL_SOFT_COMPILE = $0002;
  PCRE_STUDY_JIT_PARTIAL_HARD_COMPILE = $0004;
  PCRE_STUDY_EXTRA_NEEDED = $0008;

  (* Bit flags for the pcre[16|32]_extra structure. Do not re-arrange or redefine
     these bits, just add new ones on the end, in order to remain compatible. *)

  PCRE_EXTRA_STUDY_DATA = $0001;
  PCRE_EXTRA_MATCH_LIMIT = $0002;
  PCRE_EXTRA_CALLOUT_DATA = $0004;
  PCRE_EXTRA_TABLES = $0008;
  PCRE_EXTRA_MATCH_LIMIT_RECURSION = $0010;
  PCRE_EXTRA_MARK = $0020;
  PCRE_EXTRA_EXECUTABLE_JIT = $0040;

type
  (* Types *)
  PInteger = ^Integer;
  {$EXTERNALSYM PInteger} // NOTE: Should use Sysytem's PInteger
  PPMarshaledAString = ^PMarshaledAString;
{$NODEFINE PPMarshaledAString}
{$IFDEF PCRE16}
  PCRE_STR = MarshaledString;
{$ELSE}
  PCRE_STR = MarshaledAString;
{$ENDIF}
  PCRE_SPTR = ^PCRE_STR;
  PCRE_SPTR_PTR = ^PCRE_SPTR;

  real_pcre = record
    {magic_number: Longword;
    size: Integer;}
  end;
  TPCRE = real_pcre;
  PPCRE = ^TPCRE;

  real_pcre_jit_stack = record
  end;       (* declaration; the definition is private  *)
  TRealPCREJitStack = real_pcre_jit_stack;
  PRealPCREJitStack = ^TRealPCREJitStack;
  pcre_jit_stack = real_pcre_jit_stack;
  TPCREJitStack = pcre_jit_stack;
  PPCREJitStack = ^TPCREJitStack;

  real_pcre_extra = record
    {options: MarshaledAString;
    start_bits: array [0..31] of AnsiChar;}
    flags: Cardinal;        (* Bits for which fields are set *)
    study_data: Pointer;    (* Opaque data from pcre_study() *)
    match_limit: Cardinal;  (* Maximum number of calls to match() *)
    callout_data: Pointer;  (* Data passed back in callouts *)
    tables: PCRE_STR;       (* Pointer to character tables *)
    match_limit_recursion: Cardinal; (* Max recursive calls to match() *)
    mark: PCRE_STR;         (* For passing back a mark pointer *)
    executable_jit: Pointer; (* Contains a pointer to a compiled jit code *)
  end;
  TPCREExtra = real_pcre_extra;
  PPCREExtra = ^TPCREExtra;

  pcre_callout_block = record
    version: Integer;           (* Identifies version of block *)
  (* ------------------------ Version 0 ------------------------------- *)
    callout_number: Integer;    (* Number compiled into pattern *)
    offset_vector: PInteger;    (* The offset vector *)
    subject: PCRE_STR;          (* The subject being matched *)
    subject_length: Integer;    (* The length of the subject *)
    start_match: Integer;       (* Offset to start of this match attempt *)
    current_position: Integer;  (* Where we currently are in the subject *)
    capture_top: Integer;       (* Max current capture *)
    capture_last: Integer;      (* Most recently closed capture *)
    callout_data: Pointer;      (* Data passed in with the call *)
  (* ------------------- Added for Version 1 -------------------------- *)
    pattern_position: Integer;  (* Offset to next item in the pattern *)
    next_item_length: Integer;  (* Length of next item in the pattern *)
  (* ------------------- Added for Version 2 -------------------------- *)
    mark: PCRE_STR;             (* Pointer to current mark or NULL    *)
  (* ------------------------------------------------------------------ *)
  end;

  pcre_malloc_callback = function(Size: NativeUInt): Pointer; cdecl;
  pcre_free_callback = procedure(P: Pointer); cdecl;
  pcre_stack_malloc_callback = function(Size: NativeUInt): Pointer; cdecl;
  pcre_stack_free_callback = procedure(P: Pointer); cdecl;
  pcre_callout_callback = function(var callout_block: pcre_callout_block): Integer; cdecl;
  pcre_stack_guard_callback = function : Integer; cdecl;

procedure SetPCREMallocCallback(const Value: pcre_malloc_callback);
function GetPCREMallocCallback: pcre_malloc_callback;
function CallPCREMalloc(Size: NativeUInt): Pointer;

procedure SetPCREFreeCallback(const Value: pcre_free_callback);
function GetPCREFreeCallback: pcre_free_callback;
procedure CallPCREFree(P: Pointer);

procedure SetPCREStackMallocCallback(const Value: pcre_stack_malloc_callback);
function GetPCREStackMallocCallback: pcre_stack_malloc_callback;
function CallPCREStackMalloc(Size: NativeUInt): Pointer;

procedure SetPCREStackFreeCallback(const Value: pcre_stack_free_callback);
function GetPCREStackFreeCallback: pcre_stack_free_callback;
procedure CallPCREStackFree(P: Pointer);

procedure SetPCRECalloutCallback(const Value: pcre_callout_callback);
function GetPCRECalloutCallback: pcre_callout_callback;
function CallPCRECallout(var callout_block: pcre_callout_block): Integer;

const
{$IFDEF MACOS}
  {$IF defined(CPUARM)}   //IOS devices
    PU = '';
    LIBPCRE = 'libpcre.a';
    {$DEFINE STATIC_LIB}
  {$ELSE}
    {$IFDEF IOS}   //IOS Simulator
    PCRELib = 'libpcre.dylib';
    {$ELSE}        //OSX
    PCRELib = '/usr/lib/libpcre.dylib';
    {$ENDIF}
    {$DEFINE DYNAMIC_LIB}
  {$ENDIF}
{$ENDIF MACOS}
{$IFDEF LINUX}
  PU = '';
{$IFDEF PIC}
  LIBPCRE = 'libpcre_PIC.a';
{$ELSE  PIC}
  LIBPCRE = 'libpcre.a';
{$ENDIF PIC}
  {$DEFINE STATIC_LIB}
{$ENDIF LINUX}
{$IFDEF MSWINDOWS}
  {$IFDEF CPUX86}
  PU = '_';
  {$ELSE}
  PU = '';
  {$ENDIF}
{$ENDIF}
{$IFDEF ANDROID}
  PU = '';
  LIBPCRE = 'libpcre.a';
  {$DEFINE STATIC_LIB}
{$ENDIF ANDROID}
{$IFDEF PCRE16}
  PCREname = 'pcre16_';
{$ELSE}
  PCREname = 'pcre_';
{$ENDIF}
{$EXTERNALSYM PCREname}

(* Functions *)
{$IF Defined(MSWINDOWS) or Defined(STATIC_LIB)}
function pcre_compile(const pattern: PCRE_STR; options: Integer;
  const errptr: PMarshaledAString; erroffset: PInteger; const tableptr: MarshaledAString): PPCRE;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'compile';
function pcre_compile2(const pattern: PCRE_STR; options: Integer;
  const errorcodeptr: PInteger; const errorptr: PMarshaledAString; erroroffset: PInteger;
  const tables: MarshaledAString): PPCRE;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'compile2';
function pcre_config(what: Integer; where: Pointer): Integer;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'config';
function pcre_copy_named_substring(const code: PPCRE; const subject: PCRE_STR;
  ovector: PInteger; stringcount: Integer; const stringname: PCRE_STR;
  buffer: PCRE_STR; size: Integer): Integer;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'copy_named_substring';
function pcre_copy_substring(const subject: PCRE_STR; ovector: PInteger;
  stringcount, stringnumber: Integer; buffer: PCRE_STR; buffersize: Integer): Integer;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'copy_substring';
function pcre_dfa_exec(const argument_re: PPCRE; const extra_data: PPCREExtra;
  const subject: PCRE_STR; length: Integer; start_offset: Integer;
  options: Integer; offsets: PInteger; offsetcount: Integer; workspace: PInteger;
  wscount: Integer): Integer;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'dfa_exec';
function pcre_exec(const code: PPCRE; const extra: PPCREExtra; const subject: PCRE_STR;
  length, startoffset, options: Integer; ovector: PInteger; ovecsize: Integer): Integer;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'exec';
procedure pcre_free_substring(stringptr: PCRE_STR);
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'free_substring';
procedure pcre_free_substring_list(stringlistptr: PCRE_SPTR);
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'free_substring_list';
function pcre_fullinfo(const code: PPCRE; const extra: PPCREExtra;
  what: Integer; where: Pointer): Integer;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'fullinfo';
function pcre_get_named_substring(const code: PPCRE; const subject: PCRE_STR;
  ovector: PInteger; stringcount: Integer; const stringname: PCRE_STR;
  const stringptr: PCRE_SPTR): Integer;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'get_named_substring';
function pcre_get_stringnumber(const code: PPCRE; const stringname: PCRE_STR): Integer;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'get_stringnumber';
function pcre_get_stringtable_entries(const code: PPCRE; const stringname: PCRE_STR;
  firstptr: PCRE_SPTR; lastptr: PCRE_SPTR): Integer;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'get_stringtable_entries';
function pcre_get_substring(const subject: PCRE_STR; ovector: PInteger;
  stringcount, stringnumber: Integer; const stringptr: PCRE_SPTR): Integer;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'get_substring';
function pcre_get_substring_list(const subject: PCRE_STR; ovector: PInteger;
  stringcount: Integer; listptr: PCRE_SPTR_PTR): Integer;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'get_substring_list';
function pcre_maketables: MarshaledAString;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'maketables';
function pcre_refcount(argument_re: PPCRE; adjust: Integer): Integer;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'refcount';
function pcre_study(const code: PPCRE; options: Integer; const errptr: PMarshaledAString): PPCREExtra;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'study';
procedure pcre_free_study(extra: PPCREExtra);
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'free_study';
function pcre_version: MarshaledAString;
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + PCREname + 'version';

{$IFDEF NEXTGEN}
 {$NODEFINE pcre_study}
 {$NODEFINE pcre_compile}
 {$NODEFINE pcre_compile2}
{$ENDIF}

{$IFDEF STATIC_LIB}
// Functions added by Embarcadero in libpcre (pcre_embt_addon.c)
procedure set_pcre_malloc(addr: Pointer);
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + 'set_pcre_malloc';
procedure set_pcre_free(addr: Pointer);
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + 'set_pcre_free';
procedure set_pcre_stack_malloc(addr: Pointer);
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + 'set_pcre_stack_malloc';
procedure set_pcre_stack_free(addr: Pointer);
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + 'set_pcre_stack_free';
procedure set_pcre_callout(addr: Pointer);
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + 'set_pcre_callout';
procedure set_pcre_stack_guard(addr: Pointer);
  cdecl; external {$IFDEF STATIC_LIB}LIBPCRE{$ENDIF} name PU + 'set_pcre_stack_guard';
{$ENDIF}

{$ENDIF Defined(MSWINDOWS) or Defined(STATIC_LIB)}

{$IFDEF DYNAMIC_LIB}
var
  pcre_compile: function(const pattern: MarshaledAString; options: Integer;
    const errptr: PMarshaledAString; erroffset: PInteger; const tableptr: MarshaledAString): PPCRE; cdecl = nil;
  pcre_compile2: function(const pattern: MarshaledAString; options: Integer;
    const errorcodeptr: PInteger; const errorptr: PMarshaledAString; erroroffset: PInteger;
    const tables: MarshaledAString): PPCRE; cdecl = nil;
  pcre_config: function(what: Integer; where: Pointer): Integer; cdecl = nil;
  pcre_copy_named_substring: function(const code: PPCRE; const subject: MarshaledAString;
    ovector: PInteger; stringcount: Integer; const stringname: MarshaledAString;
    buffer: MarshaledAString; size: Integer): Integer; cdecl = nil;
  pcre_copy_substring: function(const subject: MarshaledAString; ovector: PInteger;
    stringcount, stringnumber: Integer; buffer: MarshaledAString; buffersize: Integer): Integer; cdecl = nil;
  pcre_dfa_exec: function(const argument_re: PPCRE; const extra_data: PPCREExtra;
    const subject: MarshaledAString; length: Integer; start_offset: Integer;
    options: Integer; offsets: PInteger; offsetcount: Integer; workspace: PInteger;
    wscount: Integer): Integer; cdecl = nil;
  pcre_exec: function(const code: PPCRE; const extra: PPCREExtra; const subject: MarshaledAString;
    length, startoffset, options: Integer; ovector: PInteger; ovecsize: Integer): Integer; cdecl = nil;
  pcre_free_substring: procedure(stringptr: MarshaledAString); cdecl = nil;
  pcre_free_substring_list: procedure(stringptr: PMarshaledAString); cdecl = nil;
  pcre_fullinfo: function(const code: PPCRE; const extra: PPCREExtra;
    what: Integer; where: Pointer): Integer; cdecl = nil;
  pcre_get_named_substring: function(const code: PPCRE; const subject: MarshaledAString;
    ovector: PInteger; stringcount: Integer; const stringname: MarshaledAString;
    const stringptr: PMarshaledAString): Integer; cdecl = nil;
  pcre_get_stringnumber: function(const code: PPCRE;
    const stringname: MarshaledAString): Integer; cdecl = nil;
  pcre_get_stringtable_entries: function(const code: PPCRE; const stringname: MarshaledAString;
    firstptr: PMarshaledAString; lastptr: PMarshaledAString): Integer; cdecl = nil;
  pcre_get_substring: function(const subject: MarshaledAString; ovector: PInteger;
    stringcount, stringnumber: Integer; const stringptr: PMarshaledAString): Integer; cdecl = nil;
  pcre_get_substring_list: function(const subject: MarshaledAString; ovector: PInteger;
    stringcount: Integer; listptr: PPMarshaledAString): Integer; cdecl = nil;
  pcre_info: function(const code: PPCRE; optptr, firstcharptr: PInteger): Integer; cdecl = nil;
  pcre_maketables: function: MarshaledAString; cdecl = nil;
  pcre_refcount: function(argument_re: PPCRE; adjust: Integer): Integer; cdecl = nil;
  pcre_study: function(const code: PPCRE; options: Integer; const errptr: PMarshaledAString): PPCREExtra; cdecl = nil;
  pcre_version: function: MarshaledAString; cdecl = nil;
  
{$NODEFINE pcre_get_substring_list}

function LoadPCRELib: Boolean;
procedure UnloadPCRELib;
{$ENDIF}



// Calling pcre_free in the DLL causes an access violation error; use pcre_dispose instead
procedure pcre_dispose(pattern, hints, chartable: Pointer);

implementation

{$IFDEF MSWINDOWS}
uses
  System.Win.Crtl; {$NOINCLUDE System.Win.Crtl}
{$ENDIF MSWINDOWS}
{$IF defined(DYNAMIC_LIB) and defined(POSIX)}
uses
  Posix.Dlfcn, Posix.Stdlib;
{$ENDIF}

{$IF Declared(PCRELib)}
var
  _PCRELib: THandle;
{$ENDIF}

{$IFDEF MSWINDOWS}
  {$IFDEF PCRE16}
    {$IF Defined(Win32)}
      {$L pcre16_study.obj}
      {$L pcre16_compile.obj}
      {$L pcre16_config.obj}
      {$L pcre16_dfa_exec.obj}
      {$L pcre16_exec.obj}
      {$L pcre16_fullinfo.obj}
      {$L pcre16_get.obj}
      {$L pcre16_maketables.obj}
      {$L pcre16_newline.obj}
      {$L pcre16_ord2utf16.obj}
      {$L pcre16_refcount.obj}
      {$L pcre16_tables.obj}
      {$L pcre16_string_utils.obj}
      {$L pcre16_ucd.obj}
      {$L pcre16_valid_utf16.obj}
      {$L pcre16_version.obj}
      {$L pcre16_xclass.obj}
      {$L pcre16_default_tables.obj}
    {$ELSEIF Defined(Win64)}
      {$L pcre16_study.o}
      {$L pcre16_compile.o}
      {$L pcre16_config.o}
      {$L pcre16_dfa_exec.o}
      {$L pcre16_exec.o}
      {$L pcre16_fullinfo.o}
      {$L pcre16_get.o}
      {$L pcre16_maketables.o}
      {$L pcre16_newline.o}
      {$L pcre16_ord2utf16.o}
      {$L pcre16_refcount.o}
      {$L pcre16_string_utils.o}
      {$L pcre16_tables.o}
      {$L pcre16_ucd.o}
      {$L pcre16_valid_utf16.o}
      {$L pcre16_version.o}
      {$L pcre16_xclass.o}
      {$L pcre16_default_tables.o}
    {$ENDIF}
  {$ELSE}
    {$IF Defined(Win32)}
      {$L pcre_study.obj}
      {$L pcre_compile.obj}
      {$L pcre_config.obj}
      {$L pcre_dfa_exec.obj}
      {$L pcre_exec.obj}
      {$L pcre_fullinfo.obj}
      {$L pcre_get.obj}
      {$L pcre_maketables.obj}
      {$L pcre_newline.obj}
      {$L pcre_ord2utf8.obj}
      {$L pcre_refcount.obj}
      {$L pcre_tables.obj}
      {$L pcre_ucd.obj}
      {$L pcre_valid_utf8.obj}
      {$L pcre_version.obj}
      {$L pcre_xclass.obj}
      {$L pcre_default_tables.obj}
    {$ELSEIF Defined(Win64)}
      {$L pcre_study.o}
      {$L pcre_compile.o}
      {$L pcre_config.o}
      {$L pcre_dfa_exec.o}
      {$L pcre_exec.o}
      {$L pcre_fullinfo.o}
      {$L pcre_get.o}
      {$L pcre_maketables.o}
      {$L pcre_newline.o}
      {$L pcre_ord2utf8.o}
      {$L pcre_refcount.o}
      {$L pcre_tables.o}
      {$L pcre_ucd.o}
      {$L pcre_valid_utf8.o}
      {$L pcre_version.o}
      {$L pcre_xclass.o}
      {$L pcre_default_tables.o}
    {$ENDIF}
  {$ENDIF}
{$ENDIF MSWINDOWS}

// user's defined callbacks
var
  pcre_malloc_user: pcre_malloc_callback;
  pcre_free_user: pcre_free_callback;
  pcre_stack_malloc_user: pcre_stack_malloc_callback;
  pcre_stack_free_user: pcre_stack_free_callback;
  pcre_callout_user: pcre_callout_callback;
  pcre_stack_guard_user: pcre_stack_guard_callback;

function __pcre_malloc(Size: NativeUInt): Pointer; cdecl;
begin
  if Assigned(pcre_malloc_user) then
    Result := pcre_malloc_user(Size)
  else
    Result := AllocMem(Size);
end;

function __pcre_stack_malloc(Size: NativeUInt): Pointer; cdecl;
begin
  if Assigned(pcre_stack_malloc_user) then
    Result := pcre_stack_malloc_user(Size)
  else
    Result := AllocMem(Size);
end;

procedure __pcre_free(P: Pointer); cdecl;
begin
  if Assigned(pcre_free_user) then
    pcre_free_user(P)
  else
    FreeMem(P);
end;

procedure __pcre_stack_free(P: Pointer); cdecl;
begin
  if Assigned(pcre_stack_free_user) then
    pcre_stack_free_user(P)
  else
    FreeMem(P);
end;

function __pcre_callout(var callout_block: pcre_callout_block): Integer; cdecl;
begin
  if Assigned(pcre_callout_user) then
    Result := pcre_callout_user(callout_block)
  else
    Result := 0;
end;

function __pcre_stack_guard: Integer; cdecl;
begin
  if Assigned(pcre_stack_guard_user) then
    Result := pcre_stack_guard_user
  else
    Result := 0;
end;

{$IFDEF PCRE16}
{$IFDEF WIN32}
const
  _pcre16_malloc: ^pcre_malloc_callback = @__pcre_malloc;
  _pcre16_free: ^pcre_free_callback = @__pcre_free;
  _pcre16_stack_malloc: ^pcre_stack_malloc_callback = @__pcre_stack_malloc;
  _pcre16_stack_free: ^pcre_stack_free_callback = @__pcre_stack_free;
  _pcre16_callout: ^pcre_callout_callback = @__pcre_callout;
  _pcre16_stack_guard: ^pcre_stack_guard_callback = @__pcre_stack_guard;
{$ENDIF}
{$IFDEF WIN64}
const
  pcre16_malloc: ^pcre_malloc_callback = @__pcre_malloc;
  pcre16_free: ^pcre_free_callback = @__pcre_free;
  pcre16_stack_malloc: ^pcre_stack_malloc_callback = @__pcre_stack_malloc;
  pcre16_stack_free: ^pcre_stack_free_callback = @__pcre_stack_free;
  pcre16_callout: ^pcre_callout_callback = @__pcre_callout;
  pcre16_stack_guard: ^pcre_stack_guard_callback = @__pcre_stack_guard;
{$ENDIF}
{$ELSE}
{$IFDEF WIN32}
const
  _pcre_malloc: ^pcre_malloc_callback = @__pcre_malloc;
  _pcre_free: ^pcre_free_callback = @__pcre_free;
  _pcre_stack_malloc: ^pcre_stack_malloc_callback = @__pcre_stack_malloc;
  _pcre_stack_free: ^pcre_stack_free_callback = @__pcre_stack_free;
  _pcre_callout: ^pcre_callout_callback = @__pcre_callout;
  _pcre_stack_guard: ^pcre_stack_guard_callback = @__pcre_stack_guard;
{$ENDIF}
{$IFDEF WIN64}
const
  pcre_malloc: ^pcre_malloc_callback = @__pcre_malloc;
  pcre_free: ^pcre_free_callback = @__pcre_free;
  pcre_stack_malloc: ^pcre_stack_malloc_callback = @__pcre_stack_malloc;
  pcre_stack_free: ^pcre_stack_free_callback = @__pcre_stack_free;
  pcre_callout: ^pcre_callout_callback = @__pcre_callout;
  pcre_stack_guard: ^pcre_stack_guard_callback = @__pcre_stack_guard;
{$ENDIF}
{$ENDIF}

procedure SetPCREMallocCallback(const Value: pcre_malloc_callback);
begin
  pcre_malloc_user := Value;
end;

function GetPCREMallocCallback: pcre_malloc_callback;
begin
  Result := pcre_malloc_user;
end;

function CallPCREMalloc(Size: NativeUInt): Pointer;
begin
  Result := __pcre_malloc(Size);
end;

procedure SetPCREFreeCallback(const Value: pcre_free_callback);
begin
  pcre_free_user := Value;
end;

function GetPCREFreeCallback: pcre_free_callback;
begin
  Result := pcre_free_user;
end;

procedure CallPCREFree(P: Pointer);
begin
  __pcre_free(P);
end;

procedure SetPCREStackMallocCallback(const Value: pcre_stack_malloc_callback);
begin
  pcre_stack_malloc_user := Value;
end;

function GetPCREStackMallocCallback: pcre_stack_malloc_callback;
begin
  Result := pcre_stack_malloc_user;
end;

function CallPCREStackMalloc(Size: NativeUInt): Pointer;
begin
  Result := __pcre_stack_malloc(Size);
end;

procedure SetPCREStackFreeCallback(const Value: pcre_stack_free_callback);
begin
  pcre_stack_free_user := Value;
end;

function GetPCREStackFreeCallback: pcre_stack_free_callback;
begin
  Result := pcre_stack_free_user;
end;

procedure CallPCREStackFree(P: Pointer);
begin
  __pcre_stack_free(P);
end;

procedure SetPCRECalloutCallback(const Value: pcre_callout_callback);
begin
  pcre_callout_user := Value;
end;

function GetPCRECalloutCallback: pcre_callout_callback;
begin
  Result := pcre_callout_user;
end;

function CallPCRECallout(var callout_block: pcre_callout_block): Integer;
begin
  Result := __pcre_callout(callout_block);
end;

procedure pcre_dispose(pattern, hints, chartable: Pointer);
begin
  if pattern <> nil then
    __pcre_free(pattern);
  if hints <> nil then
    __pcre_free(hints);
  if chartable <> nil then
    __pcre_free(chartable);
end;

{$IFDEF WIN64}
procedure __chkstk;
asm
end;
{$ENDIF WIN64}

{$IFDEF WIN32}
procedure __chkstk_noalloc;
asm
end;
{$ENDIF WIN64}

{$IFDEF DYNAMIC_LIB}
function LoadPCRELib: Boolean;

  function GetProcAddr(const ProcName: MarshaledAString): Pointer;
  begin
    dlerror;
    Result := dlsym(_PCRELib, ProcName);
  end;

  procedure SetCallback(const cbName: MarshaledAString; ProcPointer: Pointer);
  begin
    Pointer(GetProcAddr(cbName)^) := ProcPointer;
  end;

begin
  Result := True;
  if _PCRELib = 0 then
  begin
    Result := False;
    _PCRELib := HMODULE(dlopen(PCRELib, RTLD_LAZY));
    if _PCRELib <> 0 then
    begin
      // Setup the function pointers
      @pcre_compile := GetProcAddr('pcre_compile');
      @pcre_compile2 := GetProcAddr('pcre_compile2');
      @pcre_config := GetProcAddr('pcre_config');
      @pcre_copy_named_substring := GetProcAddr('pcre_copy_named_substring');
      @pcre_copy_substring := GetProcAddr('pcre_copy_substring');
      @pcre_dfa_exec := GetProcAddr('pcre_dfa_exec');
      @pcre_exec := GetProcAddr('pcre_exec');
      @pcre_free_substring := GetProcAddr('pcre_free_substring');
      @pcre_free_substring_list := GetProcAddr('pcre_free_substring_list');
      @pcre_fullinfo := GetProcAddr('pcre_fullinfo');
      @pcre_get_named_substring := GetProcAddr('pcre_get_named_substring');
      @pcre_get_stringnumber := GetProcAddr('pcre_get_stringnumber');
      @pcre_get_stringtable_entries := GetProcAddr('pcre_get_stringtable_entries');
      @pcre_get_substring := GetProcAddr('pcre_get_substring');
      @pcre_get_substring_list := GetProcAddr('pcre_get_substring_list');
      @pcre_info := GetProcAddr('pcre_info');
      @pcre_maketables := GetProcAddr('pcre_maketables');
      @pcre_refcount := GetProcAddr('pcre_refcount');
      @pcre_study := GetProcAddr('pcre_study');
      @pcre_version := GetProcAddr('pcre_version');

      // Hook the global variables exported from the library for memory allocation
      SetCallback('pcre_malloc', @__pcre_malloc);
      SetCallback('pcre_stack_malloc', @__pcre_stack_malloc);
      SetCallback('pcre_free', @__pcre_free);
      SetCallback('pcre_stack_free', @__pcre_stack_free);
      SetCallback('pcre_callout', @__pcre_callout);

      Result := True;
    end;
  end;
end;

procedure UnloadPCRELib;
begin
  if _PCRELib <> 0 then
    dlclose(_PCRELib);
  _PCRELib := 0;
end;
{$ENDIF}

{$IFDEF STATIC_LIB}
initialization
  set_pcre_malloc(@__pcre_malloc);
  set_pcre_stack_malloc(@__pcre_stack_malloc);
  set_pcre_free(@__pcre_free);
  set_pcre_stack_free(@__pcre_stack_free);
  set_pcre_callout(@__pcre_callout);
  set_pcre_stack_guard(@__pcre_stack_guard);
{$ENDIF STATIC_LIB}

end.

