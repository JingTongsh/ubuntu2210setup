# Ubuntu 22.10 setup

## vscode zoom in

vscode ctrl + to zoom in

## source

Software & Updates -> Download from -> ...

## software

```shell
sudo apt install vim
sudo apt install curl
sudo apt install build-essential
sudo apt install cmake
sudo apt install git
```

## magic

[Qv2ray-v2.7.0](https://github.com/Qv2ray/Qv2ray/releases/download/v2.7.0/Qv2ray-v2.7.0-linux-x64.AppImage)

[v2ray script](https://raw.githubusercontent.com/daveleung/hijkpw-scripts-mod/main/v2ray_mod1.sh)

simplified script `simp.sh`

* change version to 4.45.2
* install v2ray core only

## fcitx5

[ref](https://zhuanlan.zhihu.com/p/508797663)

```shell
sudo apt install fcitx5 \
fcitx5-chinese-addons \
fcitx5-frontend-gtk4 fcitx5-frontend-gtk3 fcitx5-frontend-gtk2 \
fcitx5-frontend-qt5
```

```shell
# 下载词库文件
wget https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.4/zhwiki-20220416.dict
# 创建存储目录
mkdir ~/.local/share/fcitx5/pinyin/dictionaries/
# 移动词库文件至该目录
mv zhwiki-20220416.dict ~/.local/share/fcitx5/pinyin/dictionaries/
```

```shell
im-config
```

`~/.bash_profile` or `/etc/profile`

```shell
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
```

theme ...
