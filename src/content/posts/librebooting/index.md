---
title: Cách mình đã giúp chiếc máy của mình chạy hoàn toàn bằng mã nguồn mở cùng Libreboot thế nào?
published: 2024-07-22
description: '3 năm đóng góp cho mã nguồn mở, liệu có đáng không?'
image: './cover.png'
tags: [libreboot, gentoo, linux, foss, oss]
category: 'oss'
draft: false 
lang: ''
---

Hello mọi người, hôm nay, tớ sẽ chia sẻ về hành trình xây dựng một hệ thống mã nguồn mở (từ firmware đến software) của tớ nha &lt;3.

Trước khi bắt đầu, tớ muốn cảnh báo trước:

* Nhiều phần tớ làm trong bài viết này có can thiệp phần cứng, nếu cậu không có kinh nghiệm thì hãy bỏ qua phần này nha.
* Tớ sẽ compile hết mọi thứ từ mã nguồn, vậy nếu muốn theo, cậu hãy setup hệ thống tản nhiệt cẩn thận, hoặc giảm số core được dùng để compile xuống nha.
* Tớ chưa chắc là hệ thống này sẽ ổn định làm daily driver cho tớ, nên tớ cũng không khuyên mọi người sử dụng làm daily driver.

Ukielah, mình cùng bắt đầu thôi nè 😽

# Chuẩn bị phần cứng

## Thiết bị được dùng để triển khai

Chiếc máy tớ xài trong bài viết ngày hôm nay là Dell OptiPlex 7020 (bản SFF). Em nó được trang bị con chip (cũ) của Intel (i7 4790) và 24GB RAM (overkill?). Ngoài ra, tớ cũng lắp thêm một chiếc SSD (qua cổng SATA) và một chiếc card mạng WiFi PCIE (chipset Realtek RTL8192EE)

Tớ sẽ sử dụng Libreboot, để khi tớ build firmware, firmware nớ sẽ không dính các binary blob của Intel (là Intel **M**anagement **E**ngine) đó. :3

## Thiết bị hỗ trợ flash firmware
Đối với thiết bị dùng để flash firmware, tớ sẽ dùng một chiếc Raspberry Pi Pico, và một chiếc kẹp Pomona 5250 (8 Pin).

Trước hết, tớ sẽ lắp đặt mọi thứ vào chiếc Raspberry Pi Pico.



![Pico Pinout for Serprog](https://av.libreboot.org/rpi_pico/pinout_serprog.png)
![SOIC8 Pinout](https://av.libreboot.org/chip/soic8.jpg) 
```
1: CS
2: MISO
3: WP
4: GND
5: MOSI
6: CLK
7: HOLD
8: VCC
```

Cậu có thể dùng hai ảnh tớ mention ở dưới để lắp dây vào chiếc Raspberry Pi Pico nhé. Chú ý, chân số 1 chính là chân được đánh dấu bởi một dấu chấm ở góc của chip.

Sau khi đã lắp đặt xong, chúng ta sẽ được một setup nhìn như vậy nè:

![connector](./connector.png)

Có thể cậu sẽ để ý, tớ không lắp hết 8 chân được cung cấp bởi chip, tại khi flash, chúng ta không cần sử dụng các hoạt động liên quan đến chân WP và CLK này.

Sau khi đã hoàn thành việc đấu dây, tớ sẽ tiền hành flash firmware để biến chiếc Pico thành Flasher (Pico Serprog) vào mạch nha.

Cậu có thể lấy file prebuilt [ở đây](https://github.com/opensensor/pico-serprog/releases/download/v1.0.0/pico_serprog.uf2), nếu không muốn tự build nha.

Giữ nút `BOOTSEL` trên Pico, rồi kéo thả file bạn đã build hoặc tải ở trên về.

All done, chúng ta đã có thể flash firmware bằng Pico.

# Cài đặt phần mềm & build source để flash firmware 

Đối với phần mềm, trong bài viết này mình sẽ sử dụng `flashrom`, cũng là một phần mềm mã nguồn mở để phục vụ cho việc đọc/ghi các chip SOIC. 

Trên macOS, mình sẽ thực hiện như sau để cài đặt `flashrom`

```shell
emladevops@kirbeeee ~ $ brew install flashrom
```

Sau khi đã hoàn thành quá trình cài đặt, chúng ta có thể cắm Pico vào và chạy thử

```shell
emladevops@kirbeeee ~ % flashrom --programmer serprog:dev=/dev/tty.usbmodem1234561:115200,spispeed=12M
```
(Thay thế `/dev/tty*` bằng đường dẫn tới cổng modem/serial của Pico).

Nếu bạn có thể nhìn thấy output như ở dưới, tức bạn đã thành công bước đầu rồi á. :3

```
serprog: Programmer name is "pico-serprog"
```

## Build firmware Libreboot

### Chuẩn bị môi trường (phần 1)

Sau khi đã chuẩn bị xong mọi thứ, chúng ta sẽ tiến hành xây dựng firmware Libreboot.

Trước hết, mình cần xác định một vài thứ cơ bản.

```
Target: OptiPlex 7020 SFF
Image: SeaBIOS / grubfirst
IOMMU: ON
```

Cậu có thể tìm hiểu thêm về những trường thông tin kia online nhé, tớ không tiện giải thích ngay trong bài viết này.

Để build firmware, tớ sẽ dùng codespace được cung cấp bởi GitHub, tại hệ thống build của Libreboot sẽ được tối ưu tốt hơn (và các dep dễ tìm hơn) trên nền tảng AMD64.

Còn đây là cấu hình tớ sẽ dùng để build nè.

![](https://i.imgur.com/6xxoFA2.png)

Ukielah, let's go :3

### Chuẩn bị môi trường (phần 2)

Trước hết, chúng ta sẽ cần set số luồng muốn sử dụng trong quá trình compile mã nguồn Libreboot.

```
export XBMK_THREADS=4 # Thay 4 thành số luồng bạn muốn dùng 
```

Tiếp theo, mình sẽ clone repo chữa mã nguồn của Libreboot và build dependencies

```
emladevops@codespace ~ $ git clone https://codeberg.org/libreboot/lbmk.git && cd lbmk
emladevops@codespace ~ $ sudo apt update
emladevops@codespace ~ $ sudo ./build dependencies ubuntu # thay thế bằng distro bạn dùng nhé :3
```

**Lưu ý: Trong trường hợp của mình, package `fonts-unifont` đã được đổi tên qua `ttf-unifont`, bạn hoàn toàn có thể đổi tên của package trong `./config/dependencies/ubuntu` nha.**

### Build firmware thui nè :3

```bash
./build roms list # Lấy danh sách tên các bản rom
./build roms dell9020sff_nri_12mb
```

Quá trình build có thể diễn ra trong thời gian dài, bạn hãy kiên nhẫn chờ đợi nha :3

Trong thời gian chờ đợi, mình sẽ giải thích sâu hơn chút về Libreboot.

Libreboot thật ra là một bản fork của Coreboot, nhưng không có các binary blobs của nhà sản xuất.

Nếu đã nghe qua Tianocore để boot các hệ thống UEFI, thì chắc chắn các bạn sẽ biết. Coreboot có một tốc độ boot cực kỳ ấn tượng, và thường được sử dụng trong các máy Chromebook của nhà Google.

Cả hai dự án Coreboot và Libreboot đều được phát triển bởi cộng đồng, vậy nên nếu thấy thích thú với việc này, bạn có thể tham gia đóng góp cho dự án.

Nếu muốn aim đến một hệ thống gọn nhẹ và không bị dính binary blobs, bạn nên tham khảo sử dụng Libreboot, tuy nhiên, sử dụng Libreboot cũng sẽ có một chút downside:

* Chỉ hỗ trợ Legacy Boot: Nếu như bạn không biết, thì Libreboot sử dụng SeaBIOS để khởi động hệ điều hành, điều này cũng không có nghĩa là bạn không thể boot những ổ đĩa được định dạng GPT, nhưng, bạn sẽ bị giới hạn trong lựa chọn khởi động bằng Grub (boot trực tiếp kernel) hoặc boot từ SeaBIOS (Master Boot Record).

* Rủi ro cao: Nếu như bạn quyết định cài đặt Libreboot bằng internal flashing, thì cũng sẽ có khả năng bạn biến chiếc máy tính của mình thành cục gạch, và sau đó, phải dùng các thiết bị hỗ trợ flash bên ngoài để cứu sống được em nó :)

Sau hơn 1h chờ đợi, mình đã build thành công source cho Libreboot, mình sẽ lấy file ở trong folder `bin/` nha.

Chúng ta sẽ tới với bước tiếp theo luôn nè.

# Lựa chọn payload

Đây là tất cả những gì có trong thư mục `bin/` sau khi chúng ta build. Đến đây chắc hẳn các bạn sẽ thắc mắc về việc dùng file nào, chúng ta hãy cùng phân tích nha.

```bash
@emladevops ➜ ~/lbmk/bin/dell9020sff_nri_12mb (master) $ ls
seabios_dell9020sff_nri_12mb_libgfxinit_corebootfb.rom           seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_usqwerty.rom
seabios_dell9020sff_nri_12mb_libgfxinit_txtmode.rom              seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_colemak.rom
seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_colemak.rom   seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_deqwertz.rom
seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_deqwertz.rom  seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_esqwerty.rom
seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_esqwerty.rom  seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_frazerty.rom
seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_frazerty.rom  seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_frdvbepo.rom
seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_frdvbepo.rom  seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_itqwerty.rom
seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_itqwerty.rom  seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_ptqwerty.rom
seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_ptqwerty.rom  seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_svenska.rom
seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_svenska.rom   seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_trqwerty.rom
seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_trqwerty.rom  seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_ukdvorak.rom
seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_ukdvorak.rom  seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_ukqwerty.rom
seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_ukqwerty.rom  seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_usdvorak.rom
seagrub_dell9020sff_nri_12mb_libgfxinit_corebootfb_usdvorak.rom  seagrub_dell9020sff_nri_12mb_libgfxinit_txtmode_usqwerty.rom
```

Nếu như để ý cần thận, bạn sẽ thấy file được đặt tên theo format sau:

`<tên payload>_<tên máy>_<chế độ init gfx>_<layout bàn phím>`

Mình sẽ giải thích từng phần nha.

[](https://i.imgur.com/U2eJtZt.png)

Trong trường hợp của mình, mình sẽ sử dụng file `seabios_dell9020sff_nri_12mb_libgfxinit_corebootfb.rom` để flash vào trong máy.

Bắt đầu flash thôi nè. :3 

# Flash BIOS

## Chuẩn bị

Trước hết, các bạn sẽ cần rút hết nguồn điện ra khỏi máy tính (chú ý phần pin CMOS), vì chúng ta sẽ cấp 3.3V cho chip BIOS bằng Pico.

Sau khi đã tháo hết nguồn điện, bạn nên dùng một cây nhíp để chập 2 chân `Power SW +` và `Power SW -` để xả hết điện khỏi hệ thống.

Nên cẩn thận ở bước này, tại nếu không chú ý, bạn có thể sẽ làm hỏng cả chip BIOS của mình.

## Chia đôi file BIOS

Đối với máy của mình, có 2 chip BIOS, một chiếc 4MB và một chiếc 8MB, vậy nên chúng ta sẽ cần làm chút "thủ thuật" để tách 2 file này (với `libreboot.rom` là file bạn đã chọn ở trên).

```bash
$ dd if=libreboot.rom of=4mb.rom bs=1M skip=8
$ dd if=libreboot.rom of=8mb.rom bs=1M count=8
```

## Kẹp 8 chân vào chip

Riêng đối với máy mình, nó sẽ có 2 chip BIOS riêng (1 bé 4MB và 1 bé 8MB). Mình sẽ bắt đầu với 4MB trước.

Tiến hành kẹp chân vào chip BIOS, nhớ chú ý chân 1 nha.

![](https://i.imgur.com/buADh5n.png)

Sau đó cắm Pico vào trong máy tính, và chúng ta sẽ bắt đầu quá trình flash.

## Xác định loại chip

Tiến hành chạy lệnh như vừa nãy để xác định loại chip: 

```
$ flashrom --programmer serprog:dev=/dev/tty.usbmodem1234561:115200,spispeed=12M
```

Và flashrom sẽ gợi ý cho bạn (hoặc mình) như sau: 

```
Multiple flash chip definitions match the detected chip(s): "MX25L3205(A)", "MX25L3205D/MX25L3208D", "MX25L3206E/MX25L3208E", "MX25L3233F/MX25L3273E"
```

Như vậy là chip của chúng ta đã được detect rồi nè.

Đọc trên datasheet của một số forum, chip của mình chính là `MX25L3206E/MX25L3208E`.

Vậy, mình sẽ thêm option `-c MX25L3206E/MX25L3208E` vào flashrom nha.

## Sao lưu dữ liệu 

Trước hết, chúng ta sẽ thực hiện việc backup dữ liệu từ chip BIOS cũ, đề phòng trường hợp BIOS Custom không tương thích, hoặc vì một lý do nào đó, bạn muốn quay lại.

```
$ flashrom --programmer serprog:dev=/dev/tty.usbmodem1234561:115200,spispeed=12M -c "MX25L3205D/MX25L3208D" -r 4mb.bak
```

Nội dung của chip sẽ được backup vào file `4mb.bak`

Tuy nhiên, do chúng ta kết nối bằng dây thủ công nên cũng chưa hẳn là ổn định, mình khuyên mọi người nên tạo thêm một file backup nữa: 

```
$ flashrom --programmer serprog:dev=/dev/tty.usbmodem1234561:115200,spispeed=12M -c "MX25L3205D/MX25L3208D" -r 4mb.bak2
```

Rồi sau đó dùng `diff` để so sánh sự khác biệt giữa 2 file:

```
diff 4mb.bak 4mb.bak2 
```

Nếu như câu lệnh trên trả về kết quả rỗng thì chúc mừng, bạn đã đọc thành công chip BIOS rồi.

(Lưu ý: Có thể thực hiện thêm vài lần để chắc chắn nha.)

## Ghi dữ liệu của BIOS mới

Sau khi quá trình backup đã hoàn tất, chúng ta sẽ tiến hành ghi nội dung của BIOS mã nguồn mở kia lên chip.

```
$ flashrom --programmer serprog:dev=/dev/tty.usbmodem1234561:115200,spispeed=12M -c "MX25L3205D/MX25L3208D" -w 4mb.rom
```

Bước này sẽ hơi mất thời gian, nhưng `flashrom` sẽ giúp bạn kiểm tra lại nội dung của chip ngay mà không cần dump thêm lần nữa.

## Mình sẽ làm tương tự với chip BIOS 8MB còn lại (từ bước chọn loại chip, sao lưu và ghi dữ liệu mới).

# Moment of truth

Sau khi đã hoàn thành việc flash BIOS, có lẽ phần này sẽ khiến bạn vô cùng hồi hộp, liệu BIOS opensource có boot được hay không.

Hãy cắm hết tất cả nguồn điện trở lại vào chiếc máy tính, bấm nút nguồn.

Nếu như thành công, thì bạn sẽ được Libreboot chào đón nồng nhiệt :>

<YouTube id="fsG0F33xTKo"/>


# Tạm kết
Tuy là quá trình cài đặt BIOS Open Source này hơi mệt mỏi, nhưng đối với mình, nó vẫn xứng đáng, tại mình muốn có một hệ thống hoàn toàn free khỏi các binary blobs (đặc biệt là Intel ME).

Nhưng nếu để nói đến sự ổn định, thì mình sẽ không đặt nhiều hi vọng vào BIOS này. Mình vẫn sẽ luôn luôn dùng macOS làm daily driver của mình, và chiếc máy được flash kia cũng sẽ chỉ là thiết bị giúp mình tập build hoặc tập chơi các source code không quan trọng.

Bạn có thể tiếp tục đi tiếp để xây dựng trên chiếc máy kia, như trong trường hợp của mình, thì mình sẽ cài `Gentoo Linux`, là một distro hoàn toàn dựa trên mã nguồn. Hãy lưu ý rằng luôn sử dụng Grub, bỏ qua hết `LILO` và `efibootmgr` nha 🥹

Bonus: Sau khi lên Libreboot, hệ thống của mình đã nhận 24GB RAM (thay vì giới hạn 16GB như của hãng).

### Feel free to contact mình on [Facebook](https://www.facebook.com/nghia.tran.1903) để được giải đáp những thắc mắc và câu hỏi của các bạn.

## Mình xin cảm ơn :Đ