---
title: Nâng cao hiệu suất làm việc cùng tiling window manager
published: 2024-03-22
description: 'Tớ sẽ chia sẻ về trải nghiệm của bản thân sau khi sử dụng tiling (và stacking) window manager trong vòng một năm'
image: './banner.png'
tags: [fctc, nix, macos, linux, wm]
category: 'productivity'
draft: false 
lang: ''
---

Xin chào mọi người, trong bài sharing ngày hôm nay, mình sẽ chia sẻ về trải nghiệm của bản thân sau khi sử dụng tiling (và stacking) window manager trong vòng một năm, công việc cũng như học tập của tớ đã cải thiện như thế nào, mời mọi người đọc bài chia sẻ của mình. 

# 1. Tiling window manager là gì?

Nếu bạn đã từng nghe qua **D**esktop **E**nvironment (như KDE, GNOME, Xfce, v.v), thì Window Manager cũng sẽ là một thứ khá quen với bạn. Chúng ta có thể phân biệt hai thứ này cơ bản như sau:

- Desktop Environment là tổng hợp các ứng dụng được ghép lại với nhau để tạo ra giao diện người dùng, tức nó sẽ bao gồm nút start menu, thanh taskbar, v.v. Các DE khác nhau sẽ có các set package khác nhau, để có một cảm giác look and feel duy nhất, từ đó giúp xây dựng lên trải nghiệm người dùng tốt hơn (UX): Ví dụ KDE sử dụng Dolphin làm trình duyệt file chính của mình, còn Xfce thì sẽ dùng Thunar làm trình duyệt file chính của mình. Các DE cũng được xây dựng với nhiều mục đích sử dụng khác nhau (VD: KDE sẽ giúp bạn có trải nghiệm tuỳ biến hệ thống tốt nhất, còn Xfce sẽ nắm đến sự gọn nhẹ trong hệ thống)
- Window Manager cũng là một phần của Desktop Environment, mọi hoạt động trong hệ thống liên quân đến vị trí của các cửa sổ bật trong hệ thống, chúng đều được quản lý bởi Window Manager. Khác với Windows hay macOS, bạn không thể bỏ qua DE chính của hệ điều hành ấy (Windows xài Windows Shell, macOS dùng Aqua). Nhưng với Linux, bạn hoàn toàn có thể bỏ qua được tất cả những thứ không cần trong Desktop Environment (điều này cũng không có nghĩa Windows hoặc macOS có thể sử dụng Tiling WM). Nhưng nếu như WM là một phần của DE, thì bạn không thể cài đặt được một mình WM để sử dụng mà không có DE, đúng chứ? Điều này hoàn toàn không đúng với Linux - một hệ điều hành có thể giúp bạn tuỳ biến từ từng package. Thay vì cài các package tự động của DE (Dolphin, Thunar để duyệt file), thì với WM, bạn sẽ phải cài đặt các package đó thủ công, từ đó mang lại tính mở rộng và cá nhân hoá hệ thống rất cao

Window Manager sẽ được chia thành 3 loại chính, trong đó bao gồm:

- Tiling window manager: Tiling WM sẽ căn các cửa sổ trên màn hình lại với nhau (như những viên gạch ở trên sàn nhà). Mỗi khi bạn mở ra cho mình một cửa sổ mới, WM sẽ gán cho cửa sổ ấy một vùng ở trên màn hình, hoàn toàn không đè lên các cửa sổ khác, nếu không hiểu, thì bạn có thể xem ảnh chụp màn hình dưới đây nhé
- Stacking window manager: Cũng giống như Tiling WM, Stacking WM cũng sẽ căn các cửa số trên màn hình một cách tự động, nhưng các cửa sổ đang mở sẽ luôn đè lên nhau, đảm bảo kích cỡ của cửa sổ luôn ở mức tối đa
- Floating window manager: Khác biệt hoàn toàn với 2 kiểu WM ở trên, Floating WM sẽ cho các cửa sổ di chuyển lơ lửng trên màn hình, tức bạn có thể kéo cửa sổ đó đi bất cứ đâu, đặt kích thước tuỳ theo ý của bản thân.

Nhiều Window Manager sẽ giúp bạn có được cả ba layout mình kể ở trên, tức bạn có thể chuyển các layout liên tục, hoặc dùng Tiling + Floating hoặc Stacking + Floating:

# 2. Tại sao mình lại sử dụng Tiling Window Manager?

Riêng với Linux, sử dụng một WM “nhẹ nhàng” còn có thể giúp bạn tiết kiệm được tài nguyên trên máy tính như CPU hoặc bộ nhớ, tại sẽ không phải load những daemon không cần thiết. 

Còn đây sẽ là những lý do chính mà mình chọn sử dụng Tiling WM:

- Bản thân mình là một người dùng macOS, nên sẽ không thể bỏ đi trình quản lý cửa sổ mặc định (Aqua) của macOS được, thay vào đó, mình sẽ dùng một ứng dụng tên `yabai` , khác với các WM trên Linux, yabai đóng vai trò như một extension với trình quản lý cửa sổ mặc định ở trên macOS.
- Setup trên màn hình được gọn gàng hơn: Trước khi sử dụng Tiling WM, thì màn hình của mình vô cùng “lộn xộn”, khi các cửa sổ này xếp chồng lên các cửa sổ khác, mỗi khi mình cần tìm, lại phải dùng đến con chuột để tương tác. Từ ngày bắt đầu sử dụng Tiling WM, mình đã ứng dụng để sử dụng các Workspace sao cho hợp lý hơn (ví dụ Workspace 10, mình thường hay để Apple Music, Workspace 1, mình để emacs và vscode).
- Sử dụng bàn phím nhiều hơn: Đối với những lập trình viên, thì bàn phím chắc hẳn là thứ không thể thiếu với các bạn, bản thân mình cũng đã nhận thấy, việc chuyển tay từ bàn phím sang chuột, chỉ để focus vào một cửa sổ, rồi quay về sử dụng bàn phím, là một việc vô cùng tốn thời gian, với Window Manager, thì mình chỉ cần một chiếc bàn phím, đã có thể di chuyển thoải mái ở trên các Workspace rồi.
- Luyện thói quen dùng `hjkl` : Nếu như bạn nào từng nghe tới text editor vim thì cũng không lạ gì 4 chữ cái này. Chúng tương đương với 4 hướng trái, xuống, lên và phải trong Vim. Sử dụng một Tiling WM sẽ giúp mình xây dựng thói quen sử dụng những phím này nhiều hơn, thay vì việc sử dụng các phím mũi tên, để thay đổi focus trên các workspace.
- Tránh việc mất tập trung: Sử dụng WM đã giúp mình nhiều trong khi cần tập trung trong công việc. Đối với setup của mình, mình luôn để các phần mềm hay công cụ giải trí ở một Workspace riêng, nên mình có thể tập trung để làm việc, mà không phải sợ bị phân tâm bởi những cửa sổ ấy đứng ở phía sau.

