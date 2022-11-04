//+------------------------------------------------------------------+
//|                                              spikeAndCandles.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
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
input int maxCandles = 5;
input ulong magicNumber = 12354;


// counter
int numberOfTradesCounter = 0;

// global varibales

string isCandleOrSpike  ="";

string boomOrCrash ="";

int startBars =0 ;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   string symbolName = _Symbol;

   if(StringFind(symbolName, "Boom") != -1)
     {

      boomOrCrash="Boom";

     }
   else
      if(StringFind(symbolName, "Crash") != -1)
        {

         boomOrCrash="Crash";

        };

// get the iitial bars

   startBars = iBars(_Symbol, PERIOD_CURRENT);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void takeTrades(double lotSize)
  {

// check whether the lotsize is greater than the min allowable lotsize
   double minLot = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);


   if(lotSize < minLot)
      lotSize = minLot;
// bid price
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
// sl

   double sl = bidPrice - (stopLossInput * 1000 * Point());

// tp
   double tp = bidPrice + (takeProfitInput * 1000 * Point());
// set magic number
   trade.SetExpertMagicNumber(magicNumber);

// trade
   trade.Buy(lotSize, _Symbol,0.0,sl,tp,"Subscribe to Wamaithas YT channel, thanks!");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {



   Print("On tick");

   int newBars = iBars(_Symbol, PERIOD_CURRENT);

   if(newBars > startBars)
     {

      double closeForLastCandle = iClose(_Symbol,PERIOD_CURRENT,1);
      double openForLastCandle = iOpen(_Symbol,PERIOD_CURRENT,1);
      // Current price or bar being formed
      double closeForCurrentCandle = iClose(_Symbol,PERIOD_CURRENT,0);
      double openForCurrentCandle = iOpen(_Symbol,PERIOD_CURRENT,0);



      if(openForLastCandle > closeForLastCandle)
        {

         isCandleOrSpike = "Spike";
         // init a trade
         takeTrades(lotSizeInput);
         // increament the counter to 1
         numberOfTradesCounter =1;

        }

      if(openForLastCandle < closeForLastCandle)
        {
         isCandleOrSpike="Candle";

        }

      // "ride the candles"
      if(numberOfTradesCounter <= maxCandles && numberOfTradesCounter > 0)
        {

         // tke a trade
         takeTrades(lotSizeInput);
         // increament counter
         numberOfTradesCounter++;

        };

      // reset the counter to zero when the current bar is a spike

      if(openForCurrentCandle > closeForCurrentCandle)
        {

         // currently forming a spike in realtime
         numberOfTradesCounter =0;
        }


      startBars = newBars;


     };




   Comment("The current chart is a crash and the current candlestick is a ", isCandleOrSpike);



  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
