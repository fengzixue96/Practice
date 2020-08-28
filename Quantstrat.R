# FINANCIAL TRADING in Quantstrat

# Load the quantstrat package
library(quantstrat)
library(quantmod)

# Get SPY from yahoo
getSymbols("SPY", 
           from = "2000-01-01", 
           to = "2016-06-30", 
           src =  "yahoo", 
           adjust =  TRUE)

# Plot the closing price of SPY
plot(Cl(SPY))

# Add a 200-day SMA using lines()
lines(SMA(Cl(SPY), n = 200), col = "red")

# Plot the RSI back 2 days
plot(RSI(Cl(SPY), n = 2))


#Initialize
#---------------------------------------------
# Create initdate, from, and to strings
initdate <- "1999-01-01"
from <- "2003-01-01"
to <- "2015-12-31"

# Set the timezone to UTC
Sys.setenv(TZ = "UTC")

# Set the currency to USD 
currency("USD")

# Use stock() to initialize SPY and set currency to USD
stock("SPY", currency = "USD")

# Define your trade size and initial equity
tradesize <- 100000
initeq <- 100000

# Define the names of your strategy, portfolio and account
strategy.st <- "firststrat"
portfolio.st <- "firststrat"
account.st <- "firststrat"

# Remove the existing strategy if it exists
rm.strat(strategy.st)

# Initialize the portfolio
initPortf(portfolio.st, symbols = "SPY", initDate = initdate, currency = "USD")

# Initialize the account
initAcct(account.st, portfolios = portfolio.st, initDate = initdate, currency = "USD", initEq = initeq)

# Initialize the orders
initOrders(portfolio.st, initDate = initdate)

# Store the strategy
strategy(strategy.st, store = TRUE)


#Indicators
#--------------------------------------
# Create a 200-day SMA
spy_sma <- SMA(x = Cl(SPY), n = 200)

# Create an RSI with a 3-day lookback period
spy_rsi <- RSI(price = Cl(SPY), n = 3)

# Add a 200-day SMA indicator to strategy.st
add.indicator(strategy = strategy.st, 
              
              # Add the SMA function
              name = "SMA", # RSI??????
              
              # Create a lookback period
              arguments = list(x = quote(Cl(mktdata)), n = 200), 
              
              # Label your indicator SMA200
              label = "SMA200")


# Write the calc_RSI_avg function (functions can be used as SMA)
calc_RSI_avg <- function(price, n1, n2) {
  
  # RSI 1 takes an input of the price and n1
  RSI_1 <- RSI(price = price, n = 3)
  
  # RSI 2 takes an input of the price and n2
  RSI_2 <- RSI(price = price, n = 4)
  
  # RSI_avg is the average of RSI_1 and RSI_2
  RSI_avg <- (RSI_1 + RSI_2)/2
  
  # Your output of RSI_avg needs a column name of RSI_avg
  colnames(RSI_avg) <- "RSI_avg"
  return(RSI_avg)
}

# Add this function as RSI_3_4 to your strategy with n1 = 3 and n2 = 4
add.indicator(strategy.st, name = calc_RSI_avg, arguments = list(price = quote(Cl(mktdata)), n1 = 3, n2 = 4), label = "RSI_3_4")


# David Varadi Oscillator (DVO) (similar to RSI)
DVO <- function(HLC, navg = 2, percentlookback = 126) {
  
  # Compute the ratio between closing prices to the average of high and low
  ratio <- Cl(HLC)/((Hi(HLC) + Lo(HLC))/2)
  
  # Smooth out the ratio outputs using a moving average
  avgratio <- SMA(ratio, n = navg)
  
  # Convert ratio into a 0-100 value using runPercentRank()
  out <- runPercentRank(avgratio, n = percentlookback, exact.multiplier = 1) * 100
  colnames(out) <- "DVO"
  return(out)
}

# Add the DVO indicator to your strategy
add.indicator(strategy = strategy.st, name = "DVO", 
              arguments = list(HLC = quote(HLC(mktdata)), navg = 2, percentlookback = 126),
              label = "DVO_2_126")

# Create intermediate data set for Debug
# HLC extracts the High, Low, and Close columns. 
# OHLC extracts the Open, High, Low, and Close columns.
head(HLC(SPY))  # xts object
tail(OHLC(SPY))
HLC(SPY["2012-01-01/2012-01-07"])
# Test indicators on them
test <- applyIndicators(strategy = strategy.st, mktdata = OHLC(SPY)) 
head(test, n = 3) 
tail(test, n = 3)
# Subset your data between Sep. 1 and Sep. 5 of 2013
test_subset <- test["2013-09-01/2013-09-05"]


# Signal (result is 1/0)
#---------------------------------------------------------
# Add a sigComparison which specifies that SMA50 must be greater than SMA200, call it longfilter
add.signal(strategy.st, name = "sigComparison", # function, can be change
           arguments = list(columns = c("SMA50", "SMA200"), # refer to the column names
                            relationship = "gt"), # gt/lt/eq/gte/lte
           label = "longfilter")

# Add a sigCrossover which specifies that the SMA50 is less than the SMA200 and label it filterexit
add.signal(strategy.st, name = "sigCrossover",
           arguments = list(columns = c("SMA50", "SMA200"),
                            relationship = "lt"),
           label = "filterexit")

# Implement a sigThreshold which specifies that DVO_2_126 must be less than 20, label it longthreshold
add.signal(strategy.st, name = "sigThreshold", 
           # Use the DVO_2_126 column
           arguments = list(column = "DVO_2_126", 
                            threshold = 20, 
                            relationship = "lt", 
                            # We're interested in every instance that the oscillator is less than 20
                            cross = FALSE), 
           label = "longthreshold")

# Add a sigThreshold signal to your strategy that specifies that DVO_2_126 must cross above 80 and label it thresholdexit
add.signal(strategy.st, name = "sigThreshold", 
           arguments = list(column = "DVO_2_126", 
                            threshold = 80, 
                            relationship = "gt", 
                            # We are interested only in the cross
                            cross = TRUE), 
           label = "thresholdexit")

# Create your dataset: test
test_init <- applyIndicators(strategy.st, mktdata = OHLC(SPY))
test <- applySignals(strategy = strategy.st, mktdata = test_init)
test["2018-10-08"]

# The idea is this: 
# You don't want to keep entering into a position for as long as conditions hold true, 
# but you do want to hold a position when there's a pullback in an uptrending environment.
# Add a sigFormula signal to your code specifying that both longfilter and longthreshold must be TRUE, label it longentry
add.signal(strategy.st, name = "sigFormula",
           
           # Specify that longfilter and longthreshold must be TRUE
           arguments = list(formula = "longfilter & longthreshold", 
                            
                            # Specify that cross must be TRUE
                            cross = TRUE),
           
           # Label it longentry
           label = "longentry")


# Rule
#---------------------------------------------------------
add.rule(strategy.st, name = "ruleSignal", 
         arguments = list(sigcol = "filterexit", # the signal column(0/1)
                          sigval = TRUE,         # switch (do/not)
                          orderqty = "all",      # "all": reduce your position to zero
                          ordertype = "market",  # others: limit(buy when below a price)/stoplimit(buy when above)
                          orderside = "long",    # long/short
                          replace = FALSE,       # TRUE: cancel all other signals
                          prefer = "Open"),      # default is "Close", "Open" can prevent a "next bar" delay; others: High/Low
         type = "exit") # sell the long position, buy is "enter"

# Create an entry rule of 1 share when all conditions line up to enter into a position
add.rule(strategy.st, name = "ruleSignal", 
         arguments=list(sigcol = "longentry", 
                        sigval = TRUE, 
                        # Set orderqty to 1, cannot be "all" when type is "enter"
                        orderqty = 1,
                        ordertype = "market",
                        orderside = "long",
                        replace = FALSE, 
                        # Buy at the next day's opening price
                        prefer = "Open"),
         type = "enter")

# Add a rule that uses an osFUN to size an entry position, dynamic, replace orderqty which is fixed
add.rule(strategy = strategy.st, name = "ruleSignal",
         arguments = list(sigcol = "longentry", sigval = TRUE, ordertype = "market",
                          orderside = "long", replace = FALSE, prefer = "Open",
                          osFUN = osMaxDollar,  # can be other functions
                          # The tradeSize/maxSize arguments should be equal to tradesize (defined earlier)
                          tradeSize = tradesize,
                          maxSize = tradesize),
         type = "enter")

# Use applyStrategy() to apply your strategy. Save this to out
out <- applyStrategy(strategy = strategy.st, portfolios = portfolio.st)

# Update your portfolio (portfolio.st)
updatePortf(portfolio.st)
daterange <- time(getPortfolio(portfolio.st)$summary)[-1]

# Update your account (account.st)
updateAcct(account.st, daterange)
updateEndEq(account.st)

# Get the tradeStats for your portfolio
tstats <- tradeStats(Portfolios = portfolio.st)

# Print the profit factor
tstats$Profit.Factor # A profit factor above 1 means your strategy is profitable. A profit factor below 1 means you should head back to the drawing board.
tstats$Percent.Positive # How many of your trades were winners


# Visualize
#------------------------------------------
# Use chart.Posn to view your system's performance on SPY
chart.Posn(Portfolio = portfolio.st, Symbol = "SPY")

# Overlay the SMA50 on your plot as a blue line
add_TA(sma50, on = 1, col = "blue")

# Overlay the SMA200 on your plot as a red line
add_TA(sma200, on = 1, col = "red")

# Add the DVO_2_126 to the plot in a new window
add_TA(dvo)

# Compute a Sharpe ratio from the actual profit and loss statistics themselves
portpl <- .blotter$portfolio.firststrat$summary$Net.Trading.PL
SharpeRatio.annualized(portpl, geometric=FALSE)
# Compute Sharpe ratio from returns
instrets <- PortfReturns(portfolio.st)
SharpeRatio.annualized(instrets, geometric = FALSE)


