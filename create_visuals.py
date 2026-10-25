import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter
from pathlib import Path

# Output folder
output_dir = Path("visuals")
output_dir.mkdir(exist_ok=True)

# Validated SQL results
years = [2015, 2016, 2017, 2018]
revenue = [484247.50, 470532.51, 609205.60, 733215.26]
profit = [49543.97, 61618.60, 81795.17, 93439.27]

# Compact currency formatting: $484K, $1.2M, etc.
def format_currency(value, _):
    if abs(value) >= 1_000_000:
        return f"${value / 1_000_000:.1f}M"
    return f"${value / 1_000:.0f}K"

# Create chart
fig, ax1 = plt.subplots(figsize=(11, 6.5))

# Revenue line
revenue_line, = ax1.plot(
    years, revenue,
    color="#2563EB",
    marker="o",
    linewidth=3,
    markersize=8,
    label="Revenue",
)
ax1.set_xlabel("Year", fontsize=11)
ax1.set_ylabel("Revenue", color="#2563EB", fontsize=11)
ax1.tick_params(axis="y", labelcolor="#2563EB")
ax1.set_xticks(years)
ax1.yaxis.set_major_formatter(FuncFormatter(format_currency))
ax1.grid(axis="y", linestyle="--", alpha=0.25)

# Profit line
ax2 = ax1.twinx()
profit_line, = ax2.plot(
    years, profit,
    color="#F97316",
    marker="s",
    linewidth=3,
    markersize=7,
    linestyle="--",
    label="Profit",
)
ax2.set_ylabel("Profit", color="#F97316", fontsize=11)
ax2.tick_params(axis="y", labelcolor="#F97316")
ax2.yaxis.set_major_formatter(FuncFormatter(format_currency))

# Combined legend
ax1.legend(
    [revenue_line, profit_line],
    ["Revenue", "Profit"],
    loc="upper left",
    frameon=False,
)

plt.title(
    "Superstore Business Performance: Revenue vs. Profit",
    fontsize=15,
    pad=18,
)
fig.tight_layout()

# Save chart
output_path = output_dir / "annual_performance.png"
fig.savefig(output_path, dpi=300, bbox_inches="tight")
plt.close(fig)

print(f"Chart saved to: {output_path.resolve()}")


# Chart 2: Profitability by Subcategory

import numpy as np
from matplotlib.ticker import FuncFormatter

subcategories = [
    "Tables", "Bookcases", "Supplies", "Fasteners", "Machines",
    "Labels", "Art", "Envelopes", "Furnishings", "Appliances",
    "Storage", "Chairs", "Binders", "Paper", "Accessories",
    "Phones", "Copiers"
]

subcategory_profit = [
    -17725.4811, -3472.5560, -1189.0995, 949.5182, 3384.7569,
    5546.2540, 6527.7870, 6964.1767, 13059.1436, 18138.0054,
    21278.8264, 26590.1663, 30221.7633, 34053.5693, 41936.6357,
    44515.7306, 55617.8249
]

# Sort from lowest to highest profit
sorted_indices = np.argsort(subcategory_profit)
categories = [subcategories[i] for i in sorted_indices]
profits = [subcategory_profit[i] for i in sorted_indices]

colors = ["#DC2626" if value < 0 else "#16A34A" for value in profits]

fig, ax = plt.subplots(figsize=(11, 8))

bars = ax.barh(categories, profits, color=colors, height=0.72)
ax.axvline(0, color="#374151", linewidth=1)

ax.xaxis.set_major_formatter(
    FuncFormatter(lambda value, _: f"-${abs(value)/1000:.0f}K"
                  if value < 0 else f"${value/1000:.0f}K")
)

ax.set_xlabel("Total Profit ($)")
ax.set_title("Superstore Profitability by Subcategory", fontsize=15, pad=14)
ax.grid(axis="x", linestyle="--", alpha=0.25)
ax.set_axisbelow(True)

# Add labels to each bar
for bar, value in zip(bars, profits):
    if value < 0:
        ax.text(
            value - 900, bar.get_y() + bar.get_height() / 2,
            f"-${abs(value)/1000:.1f}K",
            va="center", ha="right", fontsize=9
        )
    else:
        ax.text(
            value + 900, bar.get_y() + bar.get_height() / 2,
            f"${value/1000:.1f}K",
            va="center", ha="left", fontsize=9
        )

ax.set_xlim(min(profits) * 1.45, max(profits) * 1.18)
fig.tight_layout()

output_path = output_dir / "subcategory_profitability.png"
fig.savefig(output_path, dpi=300, bbox_inches="tight")
plt.close(fig)

print(f"Chart saved to: {output_path.resolve()}")


# Chart 3: Customer Segment Performance

segments = ["Consumer", "Corporate", "Home Office"]
segment_revenue = [1161401.35, 706146.37, 429653.15]
segment_margin = [11.55, 13.03, 14.03]

fig, ax1 = plt.subplots(figsize=(10, 6))

# Revenue bars
revenue_bars = ax1.bar(
    segments,
    segment_revenue,
    color=["#2563EB", "#60A5FA", "#93C5FD"],
    width=0.55,
    label="Revenue",
)

ax1.set_ylabel("Revenue", color="#2563EB")
ax1.tick_params(axis="y", labelcolor="#2563EB")
ax1.yaxis.set_major_formatter(
    FuncFormatter(lambda value, _: f"${value / 1000:.0f}K")
)
ax1.set_ylim(0, max(segment_revenue) * 1.18)
ax1.grid(axis="y", linestyle="--", alpha=0.25)
ax1.set_axisbelow(True)

# Revenue labels
for bar, value in zip(revenue_bars, segment_revenue):
    ax1.text(
        bar.get_x() + bar.get_width() / 2,
        bar.get_height() + max(segment_revenue) * 0.02,
        f"${value / 1_000_000:.2f}M" if value >= 1_000_000
        else f"${value / 1000:.1f}K",
        ha="center",
        va="bottom",
        fontsize=9,
    )

# Profit margin line on secondary axis
ax2 = ax1.twinx()
margin_line, = ax2.plot(
    segments,
    segment_margin,
    color="#F97316",
    marker="D",
    linewidth=2.5,
    markersize=8,
    label="Profit Margin",
)

ax2.set_ylabel("Profit Margin (%)", color="#F97316")
ax2.tick_params(axis="y", labelcolor="#F97316")
ax2.set_ylim(0, 18)

# Margin labels
for index, value in enumerate(segment_margin):
    ax2.annotate(
        f"{value:.2f}%",
        (index, value),
        xytext=(0, 10),
        textcoords="offset points",
        ha="center",
        color="#F97316",
        fontsize=10,
        fontweight="bold",
    )

ax1.set_title("Revenue and Profit Margin by Customer Segment", fontsize=14, pad=16)
ax1.set_xlabel("Customer Segment")

ax1.legend(
    [revenue_bars, margin_line],
    ["Revenue", "Profit Margin"],
    loc="upper right",
    frameon=False,
)

fig.tight_layout()

output_path = output_dir / "customer_segments.png"
fig.savefig(output_path, dpi=300, bbox_inches="tight")
plt.close(fig)

print(f"Chart saved to: {output_path.resolve()}")