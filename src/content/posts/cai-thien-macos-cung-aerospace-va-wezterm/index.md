---
title: Cải thiện macOS cùng AeroSpace và WezTerm
published: 2024-08-14
description: 'Cùng mình setup môi trường làm việc bằng full bàn phím cùng AeroSpace và WezTerm'
image: './cover.png'
tags: [wm, aerospace, wezterm, productivity]
category: 'productivity'
draft: false 
lang: ''
---

Hello, chào tuần mới của tháng 8 nha, tớ sẽ lại quay trở lại với một bài blog nói về trải nghiệm của tớ sau khi dùng combo AeroSpace + WezTerm mới toanh luôn nè :3.

Nếu như theo dõi blog của tớ thường xuyên, có lẽ chắc cậu cũng sẽ xem qua bài nói về việc sử dụng `yabai` của tớ rồi, nếu chưa thì cậu có thể xem lại ở [đây](https://www.twilight.fyi/posts/nang-cao-hieu-suat-lam-viec-cung-tiling-window-manager) nha

# Trước khi bắt đầu 

Trước hết, tớ sẽ giải thích lý do tại sao tớ lại chuyển qua sử dụng `AeroSpace` cũng như `WezTerm`, thay vì `yabai` và `iTerm2` như tớ đã dùng ở những bài viết trước.

Nhắc đến yabai, chắc bạn sẽ nghĩ đến ngay một hệ thống window manager bên thứ ba can thiệp rất sâu vào hệ thống. Trên macOS, chúng ta có hệ thống SIP (System Integrity Protection) (tương đương với TPM và Secure Boot trên Windows).

Yabai sẽ can thiệp vào sâu bên trong hệ thống (cụ thể là inject code riêng của mình vào Dock). Bản thân mình không gặp vấn đề gì với việc này.

Cho đến khi mình đi thực tập ngày đầu tiên và dùng máy của công ty, tất nhiên, họ sẽ không mình truy cập vào Recovery để tắt SIP. Vậy nên mình phải đi tìm một option khác để thay thế cho yabai, mà vẫn có thể sử dụng được trong môi trường của mình.

Một vòng quanh GitHub, và mình đã tìm thấy AeroSpace: Một window manager khá mới (nhưng do author đang daily driver nên mình cũng không lo lắng lắm). Vậy là, mình sẽ quyết định để đi cùng AeroSpace cho setup window manager trên macOS tiếp theo của mình.

# AeroSpace và những ưu điểm so với Yabai 

	* Không cần tắt SIP: Vấn đề này mình đã mention ở trên, bạn có thể lên để đọc lại nhé.
	* Ít lỗi hơn Yabai: Do không cần phải inject code ngoài vào trong các app macOS, AeroSpace vẫn sẽ giữ được cho mình sự ổn định khi sử dụng 
	* Cơ chế quản lý cửa sổ: Khác với yabai, khi các workspace của bạn được chia thành các Desktop ảo trên macOS, thì AeroSpace lại áp dụng cơ chế workspace ảo. Mình sẽ giải thích sâu hơn ở dưới nhé.
	* Preset thực tế: AeroSpace sẽ biết trước rất nhiều về các thuộc tính của các cửa sổ cần float (thay vì docked) như System Preferences, v.v.
	* Cấu hình bằng code: Đối với Aerospace, bạn sẽ cấu hình hoàn toàn bằng code, thay vì sử dụng shell command như trong Yabai, điều này cũng sẽ là ưu điểm cho AeroSpace, nhưng mình vẫn thích việc có thể nhúng code bằng file config yabai.
	* Hỗ trợ nhiều màn hình tốt hơn: Aerospace sẽ nhớ các vị trí mà bạn sắp đặt workspace, ví dự workspace 1 tương ứng với màn hình này, workspace 2 tương ứng với màn hình kia, khi ngắt kết nối và kết nối lại, Aerospace vẫn sẽ nhớ cấu hình như cũ. Mình thấy tính năng này rất có ích khi mình cần mang máy đi những chỗ khác (eg. phòng họp).
	* Trực quan hơn: Aerospace sẽ luôn hiện workspace mà bạn đang sử dụng trên thanh menubar, giúp việc locate dễ hơn 
	* Không bị giới hạn bởi số: Aerospace còn có thể giúp bạn tạo những workspace ảo bằng chữ, ví dụ `T` cho Terminal, `B` cho Browser, etc...

# AeroSpace và một chút những nhược điểm 

Nhắc qua đến ưu điểm rồi thì tất nhiên cũng phải có nhược điểm chứ nhỉ :3, giờ mình sẽ nhìn lại sau vài tuần sử dụng Aerospace nhé

	* Những cửa sổ tàng hình: Như đã nói ở trên, việc đặt tất cả các cửa sổ trong chung một workspace sẽ phần nào ảnh hưởng tiêu cực đến các tính năng trong macOS, tớ có thể mô tả rõ hơn khi bật Mission Control nè:

	![some bugs](https://i.imgur.com/fouyZZ8.jpeg)

	Để fix lỗi này, bạn sẽ phải bật 'Group window by application', nhưng tính năng đó cũng làm mình hơi khó chịu :/.

	* Hết rùi, không còn gì để chê :3

# Cảm nhận từ một người dùng i3wm

Mình đã dùng i3wm trên Linux trong một thời gian khá dài rồi, i3 thực sự là một window manager (dựa trên xorg) tốt nhất (theo ý kiến của mình). 
Nếu như được bắt đầu cũng AeroSpace, mình sẽ thấy mọi việc không quá khó, khi bạn được cung cấp sẵn cho một config "i3-like" tại ngay chính trang chủ [ở đây nè](https://nikitabobko.github.io/AeroSpace/config-examples#i3-like-config)

Bản thân mình là một power user của các distro *NIX (cả BSD/Linux và macOS), mình thực sự sẽ khuyên bạn nên chọn Aerospace làm điểm đến đầu tiên của mình, tại nó sẽ dễ dàng để config hơn nhiều so với yabai, tính năng nhiều hơn Rectangle hay Amethyst.

# Aerospace và Nix 
Như đã nói, Aerospace là một window manager khá mới, do đó sẽ chưa có các định nghĩa flake để dùng trên Nix, tuy nhiên, bạn có thể dùng cơ chế file của Nix để thay thế: 

```
{ config, pkgs, lib, ... }: {
	home.file.aerospace = {
		target = ".config/aerospace/aerospace.toml"
		text = ''
			# config của bạn ở đây
		''
	}
}
```

Tuy hơi bất tiện một chút, nhưng mình thấy chấp nhận được với một project mới.


Như vậy, mình đã đi qua xong các lý do mà mình chuyển qua Aerospace từ Yabai, hi vọng các bạn sẽ học được phần nào các bài học sương máu của mình. :>

# Từ iTerm2 sang WezTerm 
Đây có thể là một quyết định hơi kỳ lạ, nhưng mình cũng chuyển từ iTerm2 qua WezTerm vì lý do chính đáng: Mình thích cách config bằng file lua của WezTerm hơn GUI của iTerm2 

Cái nhìn nhanh của mình về iTerm2:
	* Một terminal emulator *cực kỳ* tốt trên macOS. 
	* Có rất nhiều tính năng hữu ích 
	* Có thể tự động hoá các action bằng Python hoặc AppleScript
	* Cấu hình bằng GUI hoặc file plist

Vậy tại sao mình lại chuyển qua WezTerm? Đơn giản là vì tính mở rộng của nó.

Như iTerm2, bạn sẽ bị giới hạn trong những gì mà nó offer (không thể viết các plugin ngoài). Nhưng với WezTerm, bạn hoàn toàn có thể config mọi thứ dựa vào file lua, cũng như tự viết plugins và helpers. Mình sẽ đính kèm config cơ bản của mình ở dưới nha. :3

```lua
-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'kanagawabones'

config.integrated_title_buttons = { 'Close' }

-- config.window_decorations = "RESIZE"

config.window_background_opacity = 0.9
config.macos_window_background_blur = 20

config.font = wezterm.font 'JetBrains Mono'
config.font_size = 15.0 

config.enable_tab_bar = false 

config.default_cursor_style = 'BlinkingBlock'
config.front_end = "WebGpu"
config.animation_fps = 60

config.cursor_blink_ease_in = "Linear"
config.cursor_blink_rate = 800


-- and finally, return the configuration to wezterm
return config
```

# Thành quả 

Và sau quá trình migration, mình được kết quả như sauu:

![result](https://i.imgur.com/f7LTerv.png)

Cảm ơn mọi người đã đọc qua bài viết của mình ạ. :3