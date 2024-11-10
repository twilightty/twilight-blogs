---
title: Từ Homebrew tới Nix, tớ đã quản lý hệ thống của mình thế nào?
published: 2024-03-16
description: 'Tớ sẽ chia sẻ về cách mình quản lý hệ thống lập trình của mình, từ một hệ thống “bừa bãi” chỉ có homebrew, tới một hệ thống tớ nắm hoàn toàn quyền bằng Nix nhé 😽'
image: './banner.png'
tags: [fctc, nix, macos, linux]
category: 'Nix'
draft: false 
lang: ''
---

Chào mọi người, trong bài sharing này, tớ sẽ chia sẻ về cách mình quản lý hệ thống lập trình của mình, từ một hệ thống “bừa bãi” chỉ có homebrew, tới một hệ thống tớ nắm hoàn toàn quyền bằng Nix nhé 😽

## 1. Ủa rồi Nix là gì??

Theo thông tin tớ tìm hiểu được, thì Nix là một trình quản lý các gói của hệ thống, khác với các trình quản lý package khác (như apt hay homebrew), thì Nix sẽ không chỉ giúp cậu quản lý các gói như apt hay homebrew, mà Nix còn giúp cậu quản lý được toàn bộ cấu hình của các gói trong hệ thống.

Hãy cứ tưởng tượng lúc cậu vừa cập nhật hệ điều hành xong, rồi có một lỗi bất ngờ xảy ra, chính cậu phải ngồi lại để cấu hình lại các package sao cho đúng với cá nhân của mình, đối với mình, thì việc đó khá tốn thời gian, mình có thể dành thời gian đó để học tập và code, đúng không nè 😽

Nix sẽ giúp cậu trong việc này, thay vì cài các package thủ công bằng tay và pull cấu hình về (dotfiles hoặc Stow của GNU), thì chúng ta có thể viết thành một file cấu hình, để dùng mỗi khi hệ thống xảy ra lỗi, và cậu phải cài đặt lại hết hệ điều hành :( 

### 1.2. Những ai nên dùng Nix?

Đối với tớ, bản thân tớ là một người luôn tìm đến những công nghệ (phần mềm) mới nhất nên sẽ sử dụng bản beta trên tất cả các thiết bị của mình. Tuy nhiên, một điểm trừ của bản beta chính là việc nó có thể hỏng một cách dễ dàng, lúc đấy, tớ sẽ phải build hết lại hệ thống để phù hợp với cấu hình cá nhân của mình.

Nix chủ yếu nhắm đến những người cần khả năng tái tạo và build package từ scratch, và cần một package có thề cài đặt được nhiều version song song với nhau.

### 1.3. “Hệ sinh thái Nix”

Đọc xong phần title, thì mình nghĩ cũng sẽ có nhiều bạn liên tưởng đến hệ sinh thái của Apple, điều đó cũng gần giống như Nix, ngoài những concept mình vừa liệt kê ở trên, thì Nix cũng có thể giúp bạn thực hiện những build release có thể tái tạo được, điều này cũng rất giống với ngành devops mà tớ đang theo.

Với Nix, chúng ta sẽ chủ yếu tập trung vào hai nhánh sau:

- NixOS: Đây là một distro Linux, nhưng khác với các distro trên thị trường, NixOS sử dụng package manager riêng của nó - NixOS. Việc cấu hình mọi thứ chỉ diễn ra trong một file trong hệ thống (`/etc/nixos/configuration.nix`).
    
    Khác với các distro sử dụng systemd, NixOS sẽ giúp bạn cấu hình toàn bộ hệ thống trong file được nêu trên, lấy ví dụ khi đặt hostname cho hệ thống, thay vì phải thực hiện việc sử dụng `echo emladevops > /etc/hostname`, thì đối với Nix, bạn chỉ cần đặt giá trị cho biên `hostname` trong file trên mà thôi.
    
- Nixpkgs: Cũng giống như các mirror của distro Linux khác, Nixpkgs là một package gallery bao gồm các gói phần mềm được viết bằng Nix, điều này sẽ giúp các bạn có thể thay đổi package đơn giản hơn (Hydra và Hackage). Nixpkgs còn hỗ trợ rất mạnh mẽ việc cross compilation (ví dụ: compile chéo `bash`  qua hệ điều hành Windows bằng `nixpkgs.pkgsCross.mingwW64.bash`

Nix còn tích hợp sâu với những service hiện đang có như `neovim` hay `nginx` , tớ sẽ lấy ví dụ nhé:

Thay vì việc cậu cấu hình một site trong nginx kiểu `/etc/nginx/site-available` , rồi viết thật nhiều code để define được trang web và server, thì trong Nix, chúng ta chỉ cần:

```jsx
services.nginx.enable = true;
services.nginx.virtualHosts."tleoj.edu.vn".webRoot = "tleoj.edu.vn";
```

Bạn thấy việc này tiện lợi hơn nhiều đúng không?

## 2. Con đường của tớ từ Homebrew sang Nix

Bản thân tớ đang sử dụng hai hệ điều hành khác nhau để phục vụ cho việc lập trình của mình (macOS và Linux), mà tớ nhận ra được việc setup các môi trường nhiều lần mỗi khi cài đặt lại thực sự rất tốn thời gian của mình, vậy nên tớ đã bắt đầu tìm hiểu về Nix, 

Từ khi sử dụng Nix, tớ đã có thể bỏ hoàn toàn việc sử dụng các lệnh trực tiếp với Homebrew qua terminal (`brew install ______`). Thay vào đó, tớ có thể define như sau:

```jsx
{config, pkgs, lib, ...}: {
    homebrew = {
        enable = true;
        global = {
            autoUpdate = false;

        };
        
        brews = [
            "git"
            "starship"
            "borders"
            "fswatch"
        ];

        casks = [
            "iterm2" #shell
            "aldente" #battery stuff
            "macfuse" # fs utils
            "karabiner-elements" #vimmy movement
            "hiddenbar" # j4f
            "obs" # why not?

        taps = [
          "homebrew/bundle"
          "homebrew/cask-fonts"
          "homebrew/services"
          "FelixKratz/formulae"  
        ];
    };
}
```

Việc này cũng làm cho tớ dễ quản lý hệ thống và package hơn, thay vì cài đặt dần các package khi cài lại hệ điều hành, thì tớ chỉ cần pull cấu hình của mình để trên Git về, và thực hiện build và switch cấu hình là đã xong rồi. 

Nix còn giúp tớ quản lý các package tốt hơn, trước hết, bạn hãy nhìn thử folder sau nhé:

```jsx
$ ls -lah /nix/store | head -7
total 111456
drwxrwxr-t@ 4516 root  nixbld   141K Mar 16 13:05 .
drwxr-xr-x     9 root  wheel    288B Mar 16 11:15 ..
drwxr-xr-x  1694 root  wheel     53K Mar 16 13:05 .links
dr-xr-xr-x     3 root  nixbld    96B Jan  1  1970 007fsdh8i9nks8fpjysa638mf7sb7a4l-libffi-3.4.6
-r--r--r--     1 root  nixbld   3.1K Jan  1  1970 007pmin3326hzdncwfbarjwxfm954gy8-xar-1.6.1.drv
dr-xr-xr-x     4 root  nixbld   128B Jan  1  1970 00b3x0f87anldfr78f4xdhncqwlhpj2q-python3.11-pynvim-0.5.0
```

Nhìn cách Nix đặt tên folder như vậy, có thể bạn sẽ cảm thấy nó hoàn toàn vô nghĩa, nhưng nó đã giúp mình rất nhiều trong việc quản lý các package trong hệ thống, thay vì để binary trong `/bin` , thì Nix sẽ thực hiện việc symlink từ `/nix/store` tới `/bin/___`, điều này không chỉ giúp mình quản lý package dễ hơn, mà còn giúp mình mỗi khi cần build một package mới 

## 3. Học Nix có khó không?

Nix không chỉ là một package manager, mà Nix còn là một ngôn ngữ lập trình, bạn có thể tưởng tượng nó kiểu JSON nhưng hỗ trợ function và link từ file này, qua file khác (`module`), Nix có syntax khá giống các ngôn ngữ ML (`SML`, `OCaml`, `Haskell`)

Bản thân mình sử dụng NixOS được một năm rồi, và sau một năm ấy, mình cũng đã tự viết được cho mình những package custom, cho nên mình cũng không nghĩ việc làm chủ Nix thực sự quá khó. Bạn sẽ thực sự thấy Nix đáng sử dụng tại tính mở rộng và reproducible của nó.

Bài viết này hoàn toàn là chia sẻ cá nhân của mình, nếu bạn thấy gì không hợp lý hoặc sai, thì hãy comment dưới bài viết này nhé, mình xin cảm ơn ạ! 😽

Tham khảo dotfiles của mình tại: 

[GitHub - emladevops/.dotfiles-nix: Darwin Nix config](https://github.com/emladevops/.dotfiles-nix?tab=readme-ov-file)
