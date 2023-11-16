----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Create Date: 01/31/2022 02:47:00 PM
-- Design Name: Graph Constructor
-- Module Name: graph_constructor_package - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Constant defintions for project signal and simulation parameters.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------------------------
-- Package
----------------------------------------------------------------------------------

package graph_constructor_package is

    ------------------------------
    -- Top
    ------------------------------
    constant FlagWidthIn                   : integer := 1;
    constant ModuleWordIn                  : std_logic := '1';
    constant HitWordIn                     : std_logic := '0';

    constant FlagWidthOut                  : integer := 4;
    constant ModuleWordOut                 : std_logic_vector(FlagWidthOut-1 downto 0) := x"8";
    constant HitWordOut                    : std_logic_vector(FlagWidthOut-1 downto 0) := x"0";

    -- HTT Event Header Format
    constant EventHeaderLength             : integer := 6;
    constant EventHeaderFlag               : std_logic_vector(7 downto 0) := X"AB";
    constant EventFooterLength             : integer := 3;
    constant EventFooterFlag               : std_logic_vector(7 downto 0) := X"CD";
    constant EventModualFlag               : std_logic_vector(7 downto 0) := X"55";
    constant EventFlagLength               : integer := 8;
    constant EventFlagBit                  : integer := 56;

    -- MW = Module Word
    constant MWInFlag                    : integer := 63;
    constant MWLayerIDMSB                : integer := 39;
    constant MWLayerIDLSB                : integer := 32;
    constant MWLayerIDWidth              : integer := MWLayerIDMSB-MWLayerIDLSB+1;

    constant MWModuleIDMSB                : integer := 15;
    constant MWModuleIDLSB                : integer := 0;
    constant MWModuleIDWidth              : integer := MWModuleIDMSB-MWModuleIDLSB+1;

    -- HW = Hit Word
    constant HWRCoordMSB                 : integer := 47;
    constant HWRCoordLSB                 : integer := 32;
    constant HWRCoordWidth               : integer := HWRCoordMSB-HWRCoordLSB+1;

    constant HWPhiCoordMSB               : integer := 31;
    constant HWPhiCoordLSB               : integer := 16;
    constant HWPhiCoordWidth             : integer := HWPhiCoordMSB-HWPhiCoordLSB+1;

    constant HWZCoordMSB                 : integer := 15;
    constant HWZCoordLSB                 : integer := 0;
    constant HWZCoordWidth               : integer := HWZCoordMSB-HWZCoordLSB+1;
    
    -- Event input interface width
    constant EventInputWidth             : integer := 64; 

    -- Data input interface width
    constant DataInputWidth              : integer := 64; 

    -- Data output interface width
    constant DataOutputWidth             : integer := 64;
    
    -- Debug
    constant DebugWidth                  : integer := 16; 
    
    ------------------------------
    -- Decoder
    ------------------------------
    -- RAW RAM
    constant RawAddrWidth                : integer := 16;
    
    ------------------------------
    -- Hit Buffer
    ------------------------------
    constant NumHitBuffer                : integer := 3;
    constant RAMType                     : string := "auto";
    constant RawDepth                    : integer := 2**RawAddrWidth;

    -- Index RAM
    constant IndexHitCountMSB            : integer := 23;
    constant IndexHitCountLSB            : integer := 16;
    constant IndexHitCountWidth          : integer := IndexHitCountMSB - IndexHitCountLSB + 1; --8

    constant IndexRawAddrMSB            : integer := 15;
    constant IndexRawAddrLSB            : integer := 0;

    constant IndexDataWidth              : integer := IndexHitCountWidth + RawAddrWidth; --24
    constant IndexAddrWidth              : integer := MWModuleIDWidth;
    constant IndexDepth                  : integer := 2**IndexAddrWidth;

    -- FLAG RAM
    constant FlagDataExp                 : integer := 10;
    constant FlagDataWidth               : integer := 2**FlagDataExp;
    constant FlagAddrWidth               : integer := MWModuleIDWidth-FlagDataExp;
    constant FlagDepth                   : integer := 2**FlagAddrWidth;

    constant FlagSetBit                  : std_logic_vector(FlagDataWidth-1 downto 0) := (0 => '1', others => '0');

    -- Data output interface width
    constant HitDataOutputWidth          : integer := 64;
    type HitBufferOutput_t is array (NumHitBuffer-1 downto 0) of std_logic_vector(HitDataOutputWidth-1 downto 0);

    -- Data output addr width
    constant HitAddrOutputWidth          : integer := RawAddrWidth;
    type HitAddrOutput_t is array (NumHitBuffer-1 downto 0) of std_logic_vector(HitAddrOutputWidth-1 downto 0);

    -- Data count interface width
    constant HitCountOutputWidth          : integer := IndexHitCountWidth;
    type HitCountOutput_t is array (NumHitBuffer-1 downto 0) of std_logic_vector(HitCountOutputWidth-1 downto 0);

    -- Event input interface width
    constant EventOutputWidth            : integer := 64;
    type EventOutput_t is array (NumHitBuffer-1 downto 0) of std_logic_vector(HitDataOutputWidth-1 downto 0); 

    ------------------------------
    -- Controller 
    ------------------------------
    type HitBufferMode_t is (writing, constructing, inferencing);
    type RWMode_t is array (NumHitBuffer-1 downto 0) of HitBufferMode_t;

    ------------------------------
    -- Output Manager
    ------------------------------
    constant MapLength                  : integer := 3;
    constant NumEdgeCalc                : integer := 2;

    -- MM = Module Map Word
    constant MMIO_Flag                   : integer := 31;

    constant MMInCountMSB                : integer := 27;
    constant MMInCountLSB                : integer := 24;
    constant MMInCountWidth              : integer := MMInCountMSB-MMInCountLSB+1;

    constant MMLayerIDMSB                : integer := 23;
    constant MMLayerIDLSB                : integer := 16;
    constant MMLayerIDWidth              : integer := MMLayerIDMSB-MMLayerIDLSB+1;

    constant MMModuleIDMSB                : integer := 15;
    constant MMModuleIDLSB                : integer := 0;
    constant MMModuleIDWidth              : integer := MMModuleIDMSB-MMModuleIDLSB+1;

    -- Module Data Info Output Interface
    constant ModuleDataOutputWidth          : integer := 64;

    constant MDIInputModCntMSB              : integer := 11;
    constant MDIInputModCntLSB              : integer := 8;
    constant MDIInputModCntWidth            : integer := MDIInputModCntMSB-MDIInputModCntLSB+1;

    constant MDIHitCntMSB                   : integer := 7;
    constant MDIHitCntLSB                   : integer := 0;
    constant MDIHitCntWidth                 : integer := MDIHitCntMSB-MDIHitCntLSB+1;

    constant ModuleDataInfoWidth            : integer := 4 + MMInCountWidth + IndexHitCountWidth; --16

    -- Modeule Map Memory
    constant ModuleMapWidth              : integer := 32; 
    constant ModuleMapAddrWidth          : integer := 16;
    constant ModuleMapDepth              : integer := 2**ModuleMapAddrWidth;

    ------------------------------
    -- Edge Calculator
    ------------------------------
    constant NumEdgeCalculators          : integer := 2;

    constant FP_Sign_Width               : integer := 1;
    constant FP_Exponent_Width           : integer := 5;
    constant FP_Fraction_Width           : integer := 10;
    constant FP_Width                    : integer := FP_Sign_Width + FP_Exponent_Width + FP_Fraction_Width;
    
    -- Output Module Hits
    constant OutHitAddrWidth             : integer := 8; --8 
    constant OutHitDepth                 : integer := 2**OutHitAddrWidth;

    -- Input Module Hits
    constant InHitAddrWidth             : integer := 10; --10
    constant InHitDepth                 : integer := 2**InHitAddrWidth;

    -- Module Info
    constant ModInfoWidth               : integer := 32;
    constant ModInfoAddrWidth           : integer := 5;
    constant ModInfoDepth               : integer := 2**ModInfoAddrWidth;

    -- Read Delay
    constant MemReadDelay               : integer := 1;
    -- Pipeline Result Delay
    constant ResultDelay                : integer := 40;

    -- Pipeline FIFOs
    constant OutHitFifoDepth            : integer := 16;
    constant HitIDFifoDepth             : integer := 16;
    constant SlopeFifoDepth             : integer := 16;
    
    -- Hit Info Word Map
    constant MIOModFlag                    : integer := 15+16;
    constant MIInModCntMSB                 : integer := 11+16;
    constant MIInModCntLSB                 : integer := 8+16;
    constant MIHitCntMSB                   : integer := 7+16;
    constant MIHitCntLSB                   : integer := 0+16;

    constant MIOffsetMSB                   : integer := InHitAddrWidth-1;
    constant MIOffsetLSB                   : integer := 0;

    -- Edge Parameters
    constant EdgeParamWidth             : integer := 4 * FP_Width;
    constant EdgeParamAddrWidth         : integer := OutHitAddrWidth + InHitAddrWidth;
    constant EdgeParamDepth             : integer := 2**EdgeParamAddrWidth;
    -- Edge Parameter Mapping
    constant RZmMSB                         : integer := 15+48;
    constant RZmLSB                         : integer := 0+48;
    constant RZbMSB                         : integer := 15+32;
    constant RZbLSB                         : integer := 0+32;
    constant RPhimMSB                       : integer := 15+16;
    constant RPhimLSB                       : integer := 0+16;
    constant RPhibMSB                       : integer := 15;
    constant RPhibLSB                       : integer := 0;

    -- Adjacency Matrix
    constant AdjMatrixWidth             : integer := 2 * RawAddrWidth;
    constant AdjMatrixAddrWidth         : integer := EdgeParamAddrWidth;
    constant AdjMatrixDepth             : integer := EdgeParamDepth;

    ------------------------------
    -- Concatenator
    ------------------------------
    constant ConcatAddrWidth         : integer := 16;
    constant ConcatDepth             : integer := 2**ConcatAddrWidth;

    type EdgeDataCount_t is array (NumEdgeCalculators-1 downto 0) of std_logic_vector(EdgeParamAddrWidth-1 downto 0); 
    type EdgeDataIn_t is array (NumEdgeCalculators-1 downto 0) of std_logic_vector(ModuleDataOutputWidth-1 downto 0); 
    type AdjIDIn_t is array (NumEdgeCalculators-1 downto 0) of std_logic_vector(RawAddrWidth*2-1 downto 0); 

    ------------------------------
    -- Testbench
    ------------------------------
    constant ClkPeriod                   : time := 10 ns;
    constant SimDataInputWidth           : integer := DataInputWidth + 4;
    constant ConcatSimDataInputWidth     : integer := DataInputWidth + 4;
    constant MaxEdgeCalcMSB              : integer := 7;  

end graph_constructor_package;


package body graph_constructor_package is

end package body graph_constructor_package;
