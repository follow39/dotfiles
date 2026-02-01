;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
	           (nongnu packages linux)
             (nongnu system linux-initrd))

(use-service-modules base cups desktop networking ssh xorg)

(use-package-modules admin audio shells linux emacs version-control package-management wm)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware amdgpu-firmware))
  (locale "en_US.utf8")
  (timezone "Europe/Berlin")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "pc")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "artem")
                  (comment "Artem")
                  (group "users")
                  (home-directory "/home/artem")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  (packages
   (cons* bluez
          bluez-alsa
          git
          stow
          emacs
          fish
          %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append 
    (list
     (service gnome-desktop-service-type)
		 (service bluetooth-service-type
              (bluetooth-configuration
               (auto-enable? #t)
               (min-connection-interval 7)
               (max-connection-interval 9)
               (connection-latency 0)
               (just-works-repairing 'confirm)))
     )
    %desktop-services
    ))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))

  (swap-devices (list (swap-space
                        (target (uuid
                                 "4291eca2-f667-49b8-b82f-8dfe2d0e9d4a")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "7E78-485E"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "adba04ee-9b29-446e-b9ad-0d277413f77d"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
