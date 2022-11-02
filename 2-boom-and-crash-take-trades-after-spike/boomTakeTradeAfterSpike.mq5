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


// trades library
#include <Trade/Trade.mqh>;

CTrade trade;

// variables user provides
input double lotSizeInput = 0.1;
input double stopLossInput = 10;
input double takeProfitInput = 10;
input int maxCandles = 5;

int magicNumber = 12345;

int numberOfTradesCounter =0;
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
void takeTrade(double lotSize)
  {
// if the lotsize is greater than min lotsize

   double minLot = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);

   if(lotSize < minLot)
      lotSize = minLot;

// make trades
// askprice
   double askPrice = SymbolInfoDouble(_Symbol,SYMBOL_ASK);

// tp

   double tp = askPrice - (takeProfitInput * 1000 * Point());

//sl
   double sl = askPrice + (stopLossInput * 1000 * Point());

//make trade
// set magic number

   trade.SetExpertMagicNumber(magicNumber);
   trade.Sell(lotSize, _Symbol, 0.0, sl, tp,"Subscribe to Wamaithas YT channel");

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {



   int newBars = iBars(_Symbol, PERIOD_CURRENT);

   if(newBars > startBars)
     {

      double closeForLastCandle = iClose(_Symbol,PERIOD_CURRENT,1);
      double openForLastCandle = iOpen(_Symbol,PERIOD_CURRENT,1);

      // current bar being formed

      double closeForCurrentCandle = iClose(_Symbol,PERIOD_CURRENT,0);
      double openForCurrentCandle = iOpen(_Symbol,PERIOD_CURRENT,0);

      if(openForLastCandle < closeForLastCandle)
        {

         isCandleOrSpike = "Spike";
         // take trade
         takeTrade(lotSizeInput);
         // increase counter by 1
         numberOfTradesCounter=1;
        }
      
         if(openForLastCandle > closeForLastCandle)
           {
            isCandleOrSpike="Candle";

           }


      // take the rest of the trades

      if(numberOfTradesCounter <= maxCandles && numberOfTradesCounter > 0)
        {
         // take trade
         takeTrade(lotSizeInput);
         // increase counter by 1
         numberOfTradesCounter++;

        }

      // reset the counter
      if(openForCurrentCandle < closeForCurrentCandle)
        {

         numberOfTradesCounter =0;
        }

      startBars = newBars;


     };




   Comment("The current chart is a ", boomOrCrash, " and the current candlestick is a ", isCandleOrSpike);



  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
