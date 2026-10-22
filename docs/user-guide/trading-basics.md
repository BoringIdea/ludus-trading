# Trading Basics

Learn how Ludus makes trading decisions and how to interpret the results.

---

## 📋 Table of Contents

- [How It Works](#how-it-works)
- [Trading Cycle](#trading-cycle)
- [Understanding Decisions](#understanding-decisions)
- [Position Management](#position-management)
- [Risk Management](#risk-management)
- [Performance Metrics](#performance-metrics)

---

## 🔄 How It Works

### Overview

Ludus is an AI-powered trading system that:

1. **Scans Markets** every 3 minutes
2. **Analyzes Data** using technical indicators
3. **Makes Decisions** using AI (DSPy + LLM)
4. **Executes Trades** on Aster DEX automatically
5. **Monitors Performance** and adjusts

```
Market Data → Technical Analysis → AI Decision → Risk Check → Execute → Monitor
     ↑                                                                      ↓
     └──────────────────────── Continuous Loop ─────────────────────────────┘
```

### Key Components

**AI Models**: 6 LLM options (DeepSeek, Qwen, Claude, Grok, Gemini, GPT)  
**Trading Pairs**: BTC, ETH, SOL, BNB, DOGE, XRP (all vs USDT)  
**Trade Types**: Long (buy) and Short (sell) positions  
**Leverage**: 1-10x (configurable)  
**Risk System**: 4-layer protection

---

## ⏱️ Trading Cycle

### What Happens Every 3 Minutes

```
1. FETCH DATA (5-10 seconds)
   ├─ Account balance and available capital
   ├─ Current open positions
   ├─ Market prices for all 6 coins
   └─ Historical data (last 100 candles)

2. TECHNICAL ANALYSIS (1-2 seconds)
   ├─ RSI (Relative Strength Index)
   ├─ MACD (Moving Average Convergence Divergence)
   ├─ EMA (Exponential Moving Average)
   └─ Volume analysis

3. AI DECISION MAKING (3-5 seconds)
   ├─ Analyze market conditions
   ├─ Evaluate each trading pair
   ├─ Consider risk/reward ratio
   ├─ Generate trading decisions (JSON)
   └─ Provide reasoning for each decision

4. RISK VALIDATION (<1 second)
   ├─ Check single trade limits
   ├─ Check total position limits
   ├─ Verify minimum order sizes
   └─ Confirm sufficient balance

5. EXECUTE TRADES (2-5 seconds per trade)
   ├─ Close positions (if decided)
   ├─ Open new positions (if decided)
   └─ Record all actions

6. LOG & UPDATE (<1 second)
   ├─ Save decision log with reasoning
   ├─ Update performance metrics
   └─ Send updates to dashboard

Total Cycle Time: ~15-30 seconds
Next Cycle: 3 minutes later
```

---

## 🤖 Understanding Decisions

### Decision Types

**1. OPEN LONG**
```json
{
  "action": "open_long",
  "symbol": "BTCUSDT",
  "quantity": 0.001,
  "leverage": 10,
  "reason": "Strong bullish momentum with RSI oversold bounce"
}
```
- **Meaning**: Buy/go long on the asset
- **Profit when**: Price goes up
- **Risk**: Price goes down

**2. OPEN SHORT**
```json
{
  "action": "open_short",
  "symbol": "ETHUSDT",
  "quantity": 0.01,
  "leverage": 10,
  "reason": "Bearish trend with resistance rejection"
}
```
- **Meaning**: Sell/go short on the asset
- **Profit when**: Price goes down
- **Risk**: Price goes up

**3. CLOSE**
```json
{
  "action": "close",
  "symbol": "SOLUSDT",
  "side": "long",
  "reason": "Take profit target reached at +10%"
}
```
- **Meaning**: Close an existing position
- **Why**: Take profit, cut losses, or reduce exposure

**4. WAIT**
```json
{
  "action": "wait",
  "reason": "No high-confidence setups; market conditions unclear"
}
```
- **Meaning**: Do nothing this cycle
- **Why**: No good opportunities, or risk limits reached

### AI Reasoning Examples

**Bullish Decision**:
```
"BTC showing strong momentum: Price broke above $68,000 resistance with high 
volume. RSI(7) at 75.3 indicates overbought but trend is strong. MACD positive 
and histogram expanding. 4h trend +3.2%. Opening long with tight 3% stop loss 
at $65,960. Risk/reward 1:3.3 (excellent). Using 30% of available balance at 
10x leverage for $300 position size."
```

**Bearish Decision**:
```
"ETH rejecting resistance at $3,900 for third time. RSI(14) at 72.5 (overbought). 
MACD showing bearish divergence. 4h downtrend -2.1%. Opening short position 
targeting $3,700 support (-5.1%). Stop loss at $3,950 (+1.3%). Risk/reward 1:4."
```

**Wait Decision**:
```
"Market conditions unclear across all pairs. BTC neutral RSI, mixed MACD signals. 
ETH in consolidation range. SOL low volume. With limited $7.50 available balance 
and existing BNB position, waiting for clearer setups. Patience preferred over 
forced trades."
```

---

## 📊 Position Management

### Position Lifecycle

```
1. OPEN
   ├─ AI identifies opportunity
   ├─ Risk checks pass
   ├─ Order placed on Aster DEX
   ├─ Position appears in dashboard
   └─ Start tracking P&L

2. MONITOR
   ├─ Track unrealized P&L
   ├─ Check against stop loss (-3%)
   ├─ Check against take profit (+10%)
   └─ Monitor market conditions

3. CLOSE
   ├─ AI decides to close OR
   ├─ Stop loss hit OR
   ├─ Take profit reached
   ├─ Opposite order placed
   └─ P&L realized

4. RECORD
   ├─ Trade saved to history
   ├─ P&L recorded
   ├─ Performance metrics updated
   └─ Available for analysis
```

### Position Information

When viewing positions on dashboard:

```
Symbol: BTCUSDT
Side: LONG ↗️
Entry Price: $68,000.00
Current Price: $68,500.00
P&L: +$0.50 (+0.74%)
Leverage: 10x
Liquidation: $61,200.00
```

**Understanding the Fields**:
- **Symbol**: Trading pair
- **Side**: LONG (bullish) or SHORT (bearish)
- **Entry Price**: Price when position opened
- **Current Price**: Latest mark price
- **P&L**: Unrealized profit/loss (changes in real-time)
- **Leverage**: Multiplier (10x means 10x exposure)
- **Liquidation**: Price where position auto-closes

---

## ⚖️ Risk Management

### 4-Layer Protection System

**Layer 1: Single Trade Limits**
```
No existing positions: Max 50% of available balance
With existing positions: Max 30% of available balance
```
*Prevents over-concentration in single trade*

**Layer 2: Total Position Limits**
```
All positions combined: Max 80% of total balance
Reserve: Always keep 20%+ available
```
*Ensures capital reserve for opportunities*

**Layer 3: Per-Position Limits**
```
Position size: Max 30% of account
Stop loss: 3% from entry price
Take profit: 10% from entry price
Max leverage: 10x
```
*Controls individual position risk*

**Layer 4: Daily Loss Limit**
```
Max daily loss: 15% of starting balance
Action: Stop trading for the day if hit
```
*Circuit breaker for bad days*

### Example Scenario

```
Account: $1,000 USDT
Available: $800 (no positions)

✅ Can open: $400 position (50% of available)
❌ Cannot open: $500 position (exceeds limit)

After opening $400 position:
Available: $400

✅ Can open: $120 position (30% of new available)
❌ Cannot open: $200 position (exceeds limit)
```

---

## 📈 Performance Metrics

### Key Metrics Explained

**Win Rate**
```
Win Rate = (Winning Trades / Total Trades) × 100%

Example: 15 wins out of 25 trades = 60% win rate
```
- **Good**: >55%
- **Excellent**: >65%
- **Note**: Quality > quantity

**Profit Factor**
```
Profit Factor = Gross Profit / Absolute Gross Loss

Example: $200 profit, $75 loss = 2.67 profit factor
```
- **Break even**: 1.0
- **Good**: >1.5
- **Excellent**: >2.0
- **Meaning**: How much you make per dollar lost

**Sharpe Ratio**
```
Sharpe Ratio = (Average Return - Risk-Free Rate) / Std Dev

Example: Sharpe of 1.85 means good risk-adjusted returns
```
- **Good**: >1.0
- **Very Good**: >2.0
- **Excellent**: >3.0
- **Meaning**: Return per unit of risk

**Max Drawdown**
```
Max Drawdown = Largest peak-to-trough decline

Example: Peak $1,100 → Trough $1,000 = -$100 (-9.1%)
```
- **Good**: <10%
- **Acceptable**: <15%
- **Warning**: >20%
- **Meaning**: Worst-case loss from peak

---

## 🎯 Trading Strategies

### How AI Chooses Trades

**Bullish Signals**:
- Price above EMA (uptrend)
- RSI < 30 (oversold, potential bounce)
- MACD > Signal (bullish momentum)
- Histogram increasing (momentum accelerating)
- Volume increasing

**Bearish Signals**:
- Price below EMA (downtrend)
- RSI > 70 (overbought, potential reversal)
- MACD < Signal (bearish momentum)
- Histogram decreasing (momentum fading)
- Rejection at resistance

**Risk/Reward**:
- Minimum 1:2 ratio (risk $1 to make $2)
- Typical: 1:3 to 1:4
- Stop loss: 3% from entry
- Take profit: 10% from entry

### Trading Philosophy

**Conservative Approach**:
- Wait for high-confidence setups
- Skip questionable opportunities
- Preserve capital > chase gains
- Quality trades > quantity

**Position Sizing**:
- Smaller account (<$100): Focus on cheaper coins (DOGE, XRP)
- Larger account (>$1000): Can trade all pairs
- Scale position size with account growth

---

## 📝 Monitoring Your Agent

### Dashboard Views

**Main Dashboard** (http://localhost:3000):
- Agent status cards
- Current balance
- Open positions
- Multi-agent equity chart

**Agent Detail Page** (click on agent card):
- Detailed account info
- Position table with real-time P&L
- Recent decisions with AI reasoning
- Performance metrics
- Trade history

### Log Files

**Main Log**: `backend/logs/roma_trading_YYYY-MM-DD.log`
```
2025-11-02 10:30:15.123 | INFO | Starting cycle #123
2025-11-02 10:30:18.456 | INFO | BTCUSDT: $68,450.23
2025-11-02 10:30:22.789 | INFO | Opening LONG BTCUSDT: 0.001 @ 10x
```

**Decision Logs**: `backend/logs/decisions/{agent_id}/decision_*.json`
```json
{
  "timestamp": "2025-11-02T10:30:00Z",
  "cycle": 123,
  "ai_reasoning": "Full analysis here...",
  "decisions": [...],
  "execution_results": [...]
}
```

---

## 🚨 What to Watch For

### Good Signs ✅
- Win rate >50%
- Profit factor >1.5
- Controlled drawdowns (<10%)
- Consistent decision-making
- Logical AI reasoning

### Warning Signs ⚠️
- Win rate <40% (after 20+ trades)
- Profit factor <1.0 (losing money)
- Large drawdowns (>15%)
- Frequent stop losses
- Illogical decisions

### Emergency Actions

**If losing >10% in a day**:
1. Stop the agent (Ctrl+C in backend terminal)
2. Review recent decisions
3. Check market conditions (extreme volatility?)
4. Adjust risk parameters
5. Restart with reduced position sizes

**If agent crashes**:
1. Check logs for errors
2. Verify API keys are valid
3. Check exchange connectivity
4. Restart: `./start.sh`

---

## 🎓 Learning Resources

### Understanding Technical Indicators

**RSI (Relative Strength Index)**:
- 0-30: Oversold (potential buy)
- 30-70: Neutral
- 70-100: Overbought (potential sell)

**MACD**:
- MACD line > Signal line: Bullish
- MACD line < Signal line: Bearish
- Histogram expanding: Momentum increasing
- Histogram shrinking: Momentum decreasing

**EMA (Exponential Moving Average)**:
- Price above EMA: Uptrend
- Price below EMA: Downtrend
- EMA acts as dynamic support/resistance

See [backend/config/README.md](../../backend/config/README.md) for detailed risk parameters.

---

## 🔗 See Also

- [Configuration Guide](configuration.md) - Adjust trading parameters
- [Risk Management](../development/risk-management.md) - Detailed risk system
- [API Reference](../api/rest-api.md) - Programmatic access
- [Troubleshooting](troubleshooting.md) - Common issues

---

**Last Updated**: November 2, 2025  
**Version**: 1.1.0

