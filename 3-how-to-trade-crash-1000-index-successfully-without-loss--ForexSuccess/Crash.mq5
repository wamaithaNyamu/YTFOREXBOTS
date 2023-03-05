//+------------------------------------------------------------------+
//|                                                         Boom.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Wamaitha"
#property link      "https://youtube.com/@wamaitha"
#property version   "1.00";

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1

//--- horizontal levels in the indicator window
#property indicator_level1 2

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
// trade library
#include <Trade/Trade.mqh>

CTrade trade;
// variables the user will define

input double lotSizeInput = 0.2;
input ulong magicNumber = 1234;


// indicator buffers
double ATRBUFFER[];

// boolean for converting buffer to series

bool AsSeries = true;

// indicator handles
int ATRHandle;


// Variables

int RSIPeriod = 10 ;
int MAPeriod = 10;

input int candlesToStayInTrade = 6;
int candlesCovered = 0 ;
bool inTrade = false;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   SetIndexBuffer(1,ATRBUFFER,INDICATOR_DATA);
   ArraySetAsSeries(ATRBUFFER,   AsSeries);
   ArrayGetAsSeries(ATRBUFFER);


   ATRHandle = iATR(_Symbol,PERIOD_CURRENT,14);

//--- if the handle is not created
   if(ATRHandle == INVALID_HANDLE)
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
   if(ATRHandle != INVALID_HANDLE)

      IndicatorRelease(ATRHandle);


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
   double open_for_current_candle = iOpen(_Symbol, PERIOD_CURRENT, 0);
   double close_for_last_candle =  iClose(_Symbol, PERIOD_CURRENT, 0);

// define a new candle forming
   if(close_for_last_candle == open_for_current_candle)
     {

      CopyBuffer(ATRHandle, 0,0,2,ATRBUFFER);
      double value_of_ATR = ATRBUFFER[0];


      // Strategy
      // Only works on M1
      // Buying when the ATR is greater than 2, take 6 candles and close
      if(value_of_ATR >= 2)
        {
         Print("ATR is above 2");
         // check if we are currently in a trade
         if(inTrade == false)
           {
            // place a buy and stay in for six candles
            trade.SetExpertMagicNumber(magicNumber);
            double min_volume = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN),_Digits);
            double useLotSize = lotSizeInput;
            if (lotSizeInput < min_volume){
               useLotSize = min_volume;
            }
            trade.Buy(useLotSize,_Symbol,0,0,0,"Subscribe to Wamaitha channel");
            inTrade = true;
           }
        }

      if(inTrade && candlesCovered <= candlesToStayInTrade)
        {

         candlesCovered = candlesCovered +1;

        }

      if(inTrade && candlesCovered == candlesToStayInTrade)
        {
        
        
         for(int i = PositionsTotal()-1; i>= 0; i--)
           {
            ulong posTicket = PositionGetTicket(i);
            CPositionInfo pos;
            if(pos.SelectByMagic(_Symbol,magicNumber))
              {

               if(pos.SelectByTicket(posTicket))
                 {
                 
                  trade.PositionClose(posTicket);
                  inTrade = false;
                  Print("position closed");
                }

              }

           }
           
           candlesCovered = 0;
        }

      Comment("The ATR value is ", value_of_ATR);

     }
  }
//+------------------------------------------------------------------+
