# Đề 3 — Mô phỏng 2×2 MIMO‑OFDM với bộ cân bằng LS

## Đề bài

**Tiếng Việt.** Mô phỏng hệ thống 2×2 MIMO‑OFDM sử dụng bộ lọc LS trên kênh Rayleigh có nhiễu trắng, điều chế 16‑QAM. Đánh giá chất lượng hệ thống bằng BER và SER.

**English.** Simulate a 2×2 MIMO-OFDM system using an LS equalizer over a Rayleigh channel with white noise and 16-QAM modulation. Measure BER and SER.

## Mô hình mô phỏng

| Thành phần | Thiết lập |
| --- | --- |
| MIMO và điều chế | 2 anten phát, 2 anten thu, 2 luồng dữ liệu 16‑QAM Gray, mỗi symbol mang 4 bit |
| OFDM | 64 sóng mang, IFFT khi phát, FFT khi thu, cyclic prefix (CP) dài 1 mẫu |
| Kênh | Hai đường Rayleigh độc lập có cùng công suất trung bình, trễ 0 và 1 mẫu. Kênh cố định trong một khung và đổi độc lập giữa các khung. |
| Khung | Hai khe pilot và một khe dữ liệu. Anten 1 phát pilot ở khe đầu, anten 2 ở khe tiếp theo. Cả hai cùng phát ở khe dữ liệu. |
| Nhiễu và SNR | Nhiễu trắng Gaussian phức (AWGN). SNR là tỷ số công suất tín hiệu trung bình trên công suất nhiễu tại mỗi anten thu trước cân bằng. |
| Thống kê | SNR từ 0 đến 30 dB, bước 5 dB. Mỗi mức dùng 1.000 khung. |

CP dài 1 mẫu vì đường trễ nhất đến chậm 1 mẫu. Mô hình giả sử đồng bộ thời gian và tần số lý tưởng. Dữ liệu được truyền trực tiếp, không dùng mã sửa lỗi.

## Xử lý tại máy thu

1. Bỏ CP và chạy FFT để lấy tín hiệu ở từng sóng mang.
2. Ước lượng kênh bằng LS. Trên mỗi sóng mang, chia ma trận pilot thu `pilotRx` cho giá trị pilot đã biết để thu được `Hls` kích thước 2×2. Hàng tương ứng anten thu, cột tương ứng anten phát.
3. Tách hai luồng dữ liệu bằng `Hls \ dataRx`. Với ma trận kênh ước lượng khả nghịch, nghiệm LS tương đương Zero‑Forcing.
4. Quyết định bit từ điểm 16‑QAM đã cân bằng và đếm lỗi. Một symbol sai nếu có ít nhất một trong bốn bit sai.

## Chạy và đọc kết quả

Mở [mimo_ofdm_ls.m](mimo_ofdm_ls.m) trong MATLAB và bấm **Run**. Script dùng các hàm MATLAB cơ bản.

- Script kiểm tra một khung không nhiễu trước khi quét SNR. BER và SER của khung này phải bằng 0.
- Bảng `SNR_dB`, `BER`, `SER` ghi tỷ lệ lỗi tại mỗi mức SNR. Mẫu số của BER là tổng bit dữ liệu đã phát. Mẫu số của SER là tổng symbol 16‑QAM dữ liệu đã phát.
- Đồ thị dùng trục tung logarit. Với cùng cấu hình máy thu, BER và SER kỳ vọng giảm khi SNR tăng. Đây là kết quả Monte Carlo nên các điểm phụ thuộc vào số khung và seed.
