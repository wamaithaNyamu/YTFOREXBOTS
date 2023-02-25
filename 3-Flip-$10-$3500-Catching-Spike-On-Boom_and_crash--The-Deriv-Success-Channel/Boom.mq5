//+------------------------------------------------------------------+
//|                                                         Boom.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Wamaitha"
#property link      "https://youtube.com/@wamaitha"
#property version   "1.00";

#property indicator_separate_window
#property indicator_buffers 5
#property indicator_plots   5
//--- limits for displaying of values in the indicator window
#property indicator_maximum 100
#property indicator_minimum 0
//--- horizontal levels in the indicator window
#property indicator_level1  90.0
#property indicator_level2  10.0

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
// trade library
#include <Trade/Trade.mqh>

CTrade trade;
// variables the user will define

input double lotSizeInput = 0.1;
input double stopLossInput = 10;
input double takeProfitInput = 10;
input ulong magicNumber = 1234;


// indicator buffers
double RSIBUFFER[];
double MABUFFER[];
double ENVUPPERBUFFER[];
double ENVLOWERBUFFER[];

// boolean for converting buffer to series

bool AsSeries = true;

// indicator handles
int RSIHandle;
int MAHandle;
int ENVUPPERHandle;
int ENVLOWERHandle;





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {




   SetIndexBuffer(1,MABUFFER,INDICATOR_DATA);
   ArraySetAsSeries(MABUFFER,   AsSeries);
   ArrayGetAsSeries(MABUFFER);


   SetIndexBuffer(2,ENVUPPERBUFFER,INDICATOR_DATA);
   ArraySetAsSeries(ENVUPPERBUFFER,   AsSeries);
   ArrayGetAsSeries(ENVUPPERBUFFER);


   SetIndexBuffer(3,ENVLOWERBUFFER,INDICATOR_DATA);
   ArraySetAsSeries(ENVLOWERBUFFER,   AsSeries);
   ArrayGetAsSeries(ENVLOWERBUFFER);


//  RSI
   RSIHandle = iRSI(_Symbol,PERIOD_CURRENT,10,PRICE_CLOSE);

//  MA
   MAHandle = iMA(_Symbol,PERIOD_CURRENT,10,0,MODE_EMA,PRICE_CLOSE);

// ENVELOPE
   ENVUPPERHandle =iEnvelopes(_Symbol,PERIOD_CURRENT,30,0,MODE_SMA,PRICE_CLOSE,0.900);
   ENVLOWERHandle =iEnvelopes(_Symbol,PERIOD_CURRENT,70,0,MODE_SMA,PRICE_CLOSE,0.900);


//--- if the handle is not created
   if(RSIHandle == INVALID_HANDLE || MAHandle == INVALID_HANDLE || ENVUPPERHandle  == INVALID_HANDLE || ENVLOWERHandle  == INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code
      Print("Failed to create one of the handles of the  indicator for the symbol %s/%s, error code %d",
            _Symbol,
            EnumToString(PERIOD_CURRENT),
            GetLastError());
      //--- the indicator is stopped early
      return(INIT_FAILED);
     };


//---
   return(INIT_SUCCEEDED);
  }
  


  
  
//+------------------------------------------------------------------+
//| Indicator deinitialization function                              |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(RSIHandle != INVALID_HANDLE || MAHandle != INVALID_HANDLE || ENVUPPERHandle  != INVALID_HANDLE || ENVLOWERHandle  != INVALID_HANDLE)

      IndicatorRelease(RSIHandle);
   IndicatorRelease(MAHandle);
   IndicatorRelease(ENVUPPERHandle);
   IndicatorRelease(ENVLOWERHandle);

//--- clear the chart after deleting the indicator
   Comment("");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

// ensure its on new candle
   double open_for_current_candle = iOpen(_Symbol, PERIOD_CURRENT, 1);
   double close_for_last_candle =  iClose(_Symbol, PERIOD_CURRENT, 0);

   if(open_for_current_candle == close_for_last_candle)
     {

      // Crash if evelope is greater than 90 and the MA touches the envelope line go for sale
      // boom if envelope is 10 or less than 10 and MA touches envelope go for buy


      // Crash if enevelope is at 10 and the ma touches the envelope go for buy

     };




  }
//+------------------------------------------------------------------+
