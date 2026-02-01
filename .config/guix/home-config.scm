(use-modules (gnu)
             (gnu system)
             (gnu packages wm)
             (gnu home)
             (gnu home services sway)
             (gnu home services syncthing))

(use-service-modules xorg networking)

(home-environment
 (packages (specifications->packages
            (list "git"
                  "ripgrep"
                  "alacritty"
                  "llvm"
                  "zig"
                  "icecat"
                  "librewolf"
                  "yubikey-manager-qt"
                  "python-yubikey-manager"
                  "font-iosevka"
                  "sway"
                  "xorg-server-xwayland")))

 (services (list
            (service home-syncthing-service-type
                     (for-home
                      (syncthing-configuration (logflags 5))))
            (service home-sway-service-type
                     (sway-configuration
                      (outputs
                       (list (sway-output
                              (identifier '*)
                              (background (file-append sway
                                                       "\
/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png"))))))))))
