# Findings Register — Superstore Business Performance Analysis

This register summarizes validated findings from the PostgreSQL analysis, supporting evidence, and reporting considerations. Findings are based on the available dataset and should not be interpreted as causal conclusions unless explicitly supported.

## 1. Data Quality and Baseline

### F01 — Initial data quality checks passed
**Status:** Verified

Validation confirmed 9,994 records, 9,994 unique Row IDs, 5,009 distinct orders, and 793 distinct customers. No exact duplicate records were identified across the 21 columns checked. Core analysis fields contain no missing values, although 11 records have missing postal codes. No invalid shipping dates, nonpositive quantities, negative sales, or discounts outside the 0–1 range were identified.

**Baseline metrics**
- Revenue: $2,297,200.86
- Profit: $286,397.02
- Profit margin: 12.47%
- Units sold: 37,873

Missing postal codes may affect geographic analysis but do not prevent the core financial analysis.

## 2. Sales Trends and Growth

### F02 — Revenue and profit grew from 2015 to 2018
**Status:** Verified

| Metric | 2015 | 2018 | Change |
|---|---:|---:|---:|
| Revenue | $484,247.50 | $733,215.26 | +51.4% |
| Profit | $49,543.97 | $93,439.27 | +88.6% |
| Profit margin | 10.23% | 12.74% | +2.51 percentage points |
| Average order value | $499.74 | $434.63 | -13.0% |

Profit grew faster than revenue over the period. However, average order value declined, and profit margin fell from its 2017 peak of 13.43% to 12.74% in 2018.

### F03 — March 2015 revenue surged without corresponding profit growth
**Status:** Verified

March 2015 revenue reached $55,691.01, up approximately 1,132.1% from February. Profit declined from $862.31 to $498.73, while profit margin fell from 19.08% to 0.90%.

Machines generated $25,314.66 in March revenue but lost $1,255.47. Tables generated $6,674.24 and lost $1,379.89. Combined, the two subcategories generated $31,988.90 in revenue and recorded a $2,635.36 loss.

These results identify areas for further investigation but do not establish that discounts alone caused the losses.

### F04 — November 2018 recorded the highest monthly revenue
**Status:** Verified

November 2018 generated $118,447.83 in revenue and $9,690.10 in profit, with an 8.18% profit margin. It was the highest-revenue month in the dataset, but its margin was below the overall margin of 12.47%.

### F05 — July 2015 recorded a monthly loss
**Status:** Verified

July 2015 generated $33,946.39 in revenue and recorded a loss of $841.48. Office Supplies contributed a loss of $2,482.02, while Furniture and Technology remained profitable that month.

## 3. Product and Profitability Drivers

### F06 — Tables, Bookcases, and Supplies were loss-making overall
**Status:** Verified

| Subcategory | Revenue | Profit | Profit margin |
|---|---:|---:|---:|
| Tables | $206,965.53 | -$17,725.48 | -8.56% |
| Bookcases | $114,880.00 | -$3,472.56 | -3.02% |
| Supplies | $46,673.54 | -$1,189.10 | -2.55% |

Tables recorded the largest cumulative loss among the subcategories. Together, these three subcategories lost approximately $22,387.14.

### F07 — Machines generated revenue but had a low overall margin
**Status:** Verified

Machines generated $189,238.63 in revenue and $3,384.76 in profit, equivalent to a 1.79% margin. Despite losses in selected periods and transactions, Machines was profitable overall.

Copiers and Accessories recorded substantially higher margins of 37.20% and 25.05%, respectively.

### F08 — Certain products and orders accounted for substantial losses
**Status:** Verified

Order `CA-2017-108196` recorded a loss of $6,892.37. Its Cubify CubeX 3D Printer Double Head Print line contributed a loss of $6,599.98—approximately 95.8% of the order's total loss—at a 70% discount.

Across the dataset, that printer model generated $11,099.96 in revenue and lost $8,879.97 across three orders. Multiple Tables products also appeared among the 25 lowest-profit products, consistent with the broader subcategory results.

These cases identify specific transactions and products for commercial review; they do not establish that discounting alone caused the losses.

## 4. Customer and Segment Analysis

### F09 — Customer segment performance differs by metric
**Status:** Verified

| Segment | Revenue | Profit | Margin | Profit per active customer |
|---|---:|---:|---:|---:|
| Consumer | $1,161,401.35 | $134,119.21 | 11.55% | $327.92 |
| Corporate | $706,146.37 | $91,979.13 | 13.03% | $389.74 |
| Home Office | $429,653.15 | $60,298.68 | 14.03% | $407.42 |

Consumer generated the highest total revenue and profit. Home Office recorded the highest profit margin and profit per active customer, while Corporate had the highest revenue per active customer.

### F10 — Some customers had negative cumulative recorded profit
**Status:** Verified

A total of 155 out of 793 customers (19.55%) had negative cumulative recorded profit. Cindy Stewart recorded the largest cumulative customer loss at $6,626.39 across six orders.

This measure reflects recorded transaction profit, not full customer profitability. Acquisition costs, service expenses, and other costs to serve are not included. Negative recorded profit alone is insufficient grounds to discontinue a customer relationship.

### F11 — Revenue was not highly concentrated among the top 10 customers
**Status:** Verified

The ten highest-revenue customers generated $153,811.17, equivalent to 6.70% of total revenue. The remaining 783 customers accounted for 93.30%.

This conclusion applies to revenue concentration among the top ten customers; profit concentration may differ.

### F12 — Previously observed customers dominated monthly activity by late 2018
**Status:** Verified, with limitation

In November 2018, 215 of 216 active customers had been observed in earlier periods of the dataset. Newly observed customer counts were much lower in later years than in 2015.

Because the dataset begins in January 2015, “newly observed” means first appearing in the available records. These results do not establish actual customer acquisition or retention rates.

## Decisions and Reporting Rules

- Do not report that the top ten customers generate 40% of revenue; the validated figure is 6.70%.
- Do not describe Machines as unprofitable overall; its full-period profit is $3,384.76.
- Treat discounting as a potential factor to investigate, not a proven cause of losses.
- Do not recommend dropping customers solely because their recorded transaction profit is negative.
- Define the time period and denominator whenever reporting customer-level metrics.
- Preserve missing postal codes as documented; do not invent values or remove records to make the dataset appear complete.
- Distinguish transaction profit from full customer profitability.
- Treat first-observed customer counts as a limitation of the available data, not as definitive acquisition or retention measures.
- Preserve the source data and investigate unusual results rather than automatically treating them as data errors.