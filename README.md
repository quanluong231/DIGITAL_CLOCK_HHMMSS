# DIGITAL CLOCK HH:MM:SS


- Giờ: `00 -> 23`
- Phút: `00 -> 59`
- Giây: `00 -> 59`
- Chuyển ngày: `23:59:59 -> 00:00:00`

## Cấu trúc

```text
DIGITAL_CLOCK_HHMMSS/
├── src/
│   ├── clock_divider.v
│   ├── counter_block.v
│   ├── display_block.v
│   └── top_module.v
├── sim/
│   └── tb_counter_block.v
└── README.md
```

## Luồng logic

```text
Master CLK
    |
    v
clock_divider
    |
  tick_1s
    |
    v
Seconds 00-59
    |
    v
Minutes 00-59
    |
    v
Hours 00-23
    |
    +---- 23:59:59 -> 00:00:00
```

Các chữ số được giữ dưới dạng BCD riêng, không dùng phép chia `/10` hoặc `%10` trong counter.

## Top-level ports

- `clk`: clock FPGA
- `reset`: reset bất đồng bộ, active-high
- `enable`: 1 = chạy, 0 = dừng
- `seg[6:0]`: 7-segment active-low
- `an[5:0]`: chọn 6 digit active-low
- các output BCD `hour_*`, `min_*`, `sec_*` để debug/simulation

Mặc định `CLK_FREQ = 50_000_000`. Nếu board dùng 100 MHz, đổi parameter thành `100_000_000`.

## Simulation với Icarus Verilog

Từ thư mục gốc project:

```bash
iverilog -o sim/sim_clock src/counter_block.v sim/tb_counter_block.v
vvp sim/sim_clock
```

Testbench kiểm tra:

- `00:00:00 -> 00:01:00`
- `00:01:00 -> 01:00:00`
- sau 24 giờ trở về `00:00:00`
- `enable = 0` thì đồng hồ dừng
