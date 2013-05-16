ckly secure UNIX/Linux systems#!/bin/bash
#
# Copyright 2013, Timothy Marcinowski (marshyski@gmail.com), USA
# Web site: https://github.com/marshyski/quick_secure
#
# Quick NIX Secure Script comes with ABSOLUTELY NO WARRANTY. This is free 
# software, and you are welcome to redistribute it under the terms of the 
# GNU General Public License. See LICENSE file for usage of this software.
#
################################################################################
#
# Quick NIX Secure Script is meant to quickly secure UNIX/Linux systems
# Version 1.0 | 16-MAY-2013 | GNU GENERAL PUBLIC LICENSE Version 3
#
################################################################################
#                                                   
# Review script's comments "#" if you want to apply any other best practices
# to your system, uncomment.  Want to better this or recommend fixes? Submit 
# a pull request or email POC above.                               
#                                             
#################################################################################

#### CHECK IF ROOT IS RUNNING QUICK NIX SECURE SCRIPT
if [[ $UID != 0 ]]; then
   echo "Sorry, must sudo or be root to run this.  Exiting..."
   exit
fi


#### DISPLAY COMMENTED OUT ITEMS AND VARIABLES FOR REVIEW
if [[ $1 = "-c" ]]; then
   echo ""
   echo "==VARIABLES OF QUICK NIX SECURE SCRIPT=="
   cat $0 | grep ^[A-Z]
   echo ""
   echo "==COMMENTED OUT SECTION OF SCRIPT=="
   grep ^#[a-z] $0
   exit
fi

if [[ $1 = "-u" ]]; then
   echo ""
   cat $0 | sed 's/^[ \t]*//;s/[ \t]*$//' | grep '.' | grep -v ^#
   exit
fi


#### SET VARIABLES OF SCRIPT
PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/kerberos/sbin:/usr/kerberos/bin"
PASS_EXPIRE="60" #used to set password expire in days for root


#### DISCLAIMER
echo "Quick NIX Secure Script Copyright (C) 2013 Timothy Marcinowski"
echo ""
echo "# QUICK NIX SECURE SCRIPT HAS NO WARRANTY OF ANY KIND       #"
echo "# PLEASE REVIEW SCRIPT BEFORE SECURING YOUR SYSTEM(S)       #"
echo "# PLEASE USE WITH CAUTION AND DILIGENCE!!!                  #"
echo ""
echo "  quick_secure.sh -c | Review what's commented out in script"
echo "  quick_secure.sh -u | Review what's being applied to system"
echo "  quick_secure.sh -f | Force settings, never prompt question"
echo ""
echo "# THIS WILL BREAK RHEL/CENTOS 6 GNOME GUI!!!                #"
echo ""


#### VERIFY ADMIN WANTS TO HARDEN SYSTEM
if [[ $1 != "-f" ]]; then
   echo -n "Are you sure you want to quick secure `hostname` (Y/n)? "
   read ANSWER
   while true; do
      if [[ "$ANSWER" != "Y" ]]; then
         if [[ "$ANSWER" != "n" ]]; then
            echo "'$ANSWER' invaild input"
            echo -n "Are you sure you want to quick secure `hostname` (Y/n)? "
            read ANSWER
         fi
      fi
      
      if [[ $ANSWER = "n" ]]; then
         echo ""
         echo "Exiting..."
         exit
      fi
      
      if [[ $ANSWER = "Y" ]]; then
         break
      fi
   done
   echo ""
fi


#### SET AUDIT GROUP VARIABLE
if [[ `grep -i ^audit /etc/group` != "" ]]; then
   AUDIT=`grep -i ^audit /etc/group | awk -F":" '{ print $1 }' | head -n 1`
else
   AUDIT="root"
fi

echo "Audit group is set to '$AUDIT'"
echo ""


#### SETUP /etc/motd AND /etc/issues
echo "" > /etc/motd
echo "" > /etc/issue.net
#rm -f /etc/issue /etc/issue.net
#ln -s /etc/motd /etc/issue
#ln -s /etc/motd /etc/issue.net
chown -f root:root /etc/motd /etc/issue*
chmod -f 0444 /etc/motd /etc/issue*


#### CRON SETUP
if [[ -f /etc/cron.allow ]]; then
   if [[ `grep root /etc/cron.allow` != "root" ]]; then
      echo "root" > /etc/cron.allow
      rm -f /etc/at.deny
   else
      echo "root is already in /etc/cron.allow"
      echo ""
   fi
fi

if [[ -f /etc/cron.allow ]]; then
   if [[ ! -f /etc/at.allow ]]; then
      touch /etc/at.allow
   fi
fi

if [[ `grep root /etc/at.allow 2>/dev/null` != "root" ]]; then
   echo "root" > /etc/at.allow
   rm -f /etc/at.deny
else
   echo "root is already in /etc/at.allow"
   echo ""
fi

if [[ `cat /etc/at.deny` = "" ]]; then
   rm -f /etc/at.deny
fi

if [[ `cat /etc/cron.deny` = "" ]]; then
   rm -f /etc/cron.deny
fi


chmod -f 0700 /etc/cron.monthly/*
chmod -f 0700 /etc/cron.weekly/*
chmod -f 0700 /etc/cron.daily/*
chmod -f 0700 /etc/cron.hourly/*
chmod -f 0700 /etc/cron.d/*
chmod -f 0400 /etc/cron.allow
chmod -f 0400 /etc/cron.deny
chmod -f 0400 /etc/crontab
chmod -f 0400 /etc/at.allow
chmod -f 0400 /etc/at.deny
chmod -f 0700 /etc/cron.daily
chmod -f 0700 /etc/cron.weekly
chmod -f 0700 /etc/cron.monthly
chmod -f 0700 /etc/cron.hourly
chmod -f 0700 /var/spool/cron
chmod -f 0600 /var/spool/cron/*
chmod -f 0700 /var/spool/at
chmod -f 0600 /var/spool/at/*
chmod -f 0400 /etc/anacrontab


#### TEMP DIRECTORIES
chmod -f 1777 /tmp

#if [[ -d /var/tmp ]]; then
#   rm -Rf /var/tmp
#   ln -s /tmp /var/tmp
#else
#    ln -s /tmp /var/tmp
#fi

#if [[ -d /usr/tmp ]]; then
#   rm -Rf /usr/tmp
#   ln -s /tmp /usr/tmp
#else
#    ln -s /tmp /usr/tmp
#fi


#### FILE PERMISSIONS AND OWNERSHIPS
chown -f root:root /var/crash
chown -f root:root /var/cache/mod_proxy
chown -f root:root /var/lib/dav
chown -f root:root /usr/bin/lockfile
chown -f rpcuser:rpcuser /var/lib/nfs/statd
chown -f adm:adm /var/adm
chmod -f 0600 /var/crash
chown -f root:root /bin/mail
chmod -f 0700 /sbin/reboot
chmod -f 0700 /sbin/shutdown
chmod -f 0600 /etc/ssh/ssh*config
chown -f root:root /root
chmod -f 0700 /root
chmod -f 0500 /usr/bin/ypcat
chmod -f 0700 /usr/sbin/usernetctl
chmod -f 0700 /usr/bin/rlogin
chmod -f 0700 /usr/bin/rcp
chmod -f 0640 /etc/pam.d/system-auth*
chmod -f 0640 /etc/login.defs
chmod -f 0750 /etc/security
chmod -f 0600 /etc/audit/audit.rules
chown -f root:root /etc/audit/audit.rules
chmod -f 0600 /etc/audit/auditd.conf
chown -f root:root /etc/audit/auditd.conf
chmod -f 0600 /etc/auditd.conf
chmod -f 0744 /etc/rc.d/init.d/auditd
chown -f root /sbin/auditctl
chmod -f 0750 /sbin/auditctl
chown -f root /sbin/auditd
chmod -f 0750 /sbin/auditd
chmod -f 0750 /sbin/ausearch
chown -f root /sbin/ausearch
chown -f root /sbin/aureport
chmod -f 0750 /sbin/aureport
chown -f root /sbin/autrace
chmod -f 0750 /sbin/autrace
chown -f root /sbin/audispd
chmod -f 0750 /sbin/audispd
chmod -f 0444 /etc/bashrc
chmod -f 0444 /etc/csh.cshrc
chmod -f 0444 /etc/csh.login
chmod -f 0600 /etc/cups/client.conf
chmod -f 0600 /etc/cups/cupsd.conf
chown -f root:sys /etc/cups/client.conf
chown -f root:sys /etc/cups/cupsd.conf
chmod -f 0600 /etc/grub.conf
chown -f root:root /etc/grub.conf
chmod -f 0600 /boot/grub2/grub.cfg
chown -f root:root /boot/grub2/grub.cfg
chmod -f 0600 /boot/grub/grub.cfg
chown -f root:root /boot/grub/grub.cfg
chmod -f 0444 /etc/hosts
chown -f root:root /etc/hosts
chmod -f 0600 /etc/inittab
chown -f root:root /etc/inittab
chmod -f 0444 /etc/mail/sendmail.cf
chown -f root:bin /etc/mail/sendmail.cf
chmod -f 0600 /etc/ntp.conf
chmod -f 0640 /etc/security/access.conf
chmod -f 0600 /etc/security/console.perms
chmod -f 0600 /etc/security/console.perms.d/50-default.perms
chmod -f 0600 /etc/security/limits
chmod -f 0444 /etc/services
chmod -f 0444 /etc/shells
chmod -f 0644 /etc/skel/.*
chmod -f 0600 /etc/skel/.bashrc
chmod -f 0600 /etc/skel/.bash_profile
chmod -f 0600 /etc/skel/.bash_logout
chmod -f 0440 /etc/sudoers
chown -f root:root /etc/sudoers
chmod -f 0600 /etc/sysctl.conf
chown -f root:root /etc/sysctl.conf
chown -f root:root /etc/sysctl.d/*
chmod -f 0700 /etc/sysctl.d
chmod -f 0600 /etc/sysctl.d/*
chmod -f 0600 /etc/syslog.conf
chmod -f 0600 /var/yp/binding
chown -f root:$AUDIT /var/log
chown -Rf root:$AUDIT /var/log/*
chmod -Rf 0640 /var/log/*
chmod -Rf 0640 /var/log/audit/*
chmod -f 0755 /var/log 
chmod -f 0750 /var/log/syslog /var/log/audit
chmod -f 0600 /var/log/lastlog*
chmod -f 0600 /var/log/cron*
chmod -f 0444 /etc/profile
chmod -f 0700 /etc/rc.d/rc.local
chmod -f 0400 /etc/securetty
chmod -f 0700 /etc/rc.local
chmod -f 0750 /usr/bin/wall
chown -f root:tty /usr/bin/wall
chown -f root:users /mnt
chown -f root:users /media
chmod -f 0644 /etc/.login
chmod -f 0644 /etc/profile.d/*
chown -f root /etc/security/environ
chown -f root /etc/xinetd.d
chown -f root /etc/xinetd.d/*
chmod -f 0750 /etc/xinetd.d
chmod -f 0640 /etc/xinetd.d/*
chmod -f 0640 /etc/selinux/config
chmod -f 0750 /usr/bin/chfn 
chmod -f 0750 /usr/bin/chsh 
chmod -f 0750 /usr/bin/write 
chmod -f 0750 /sbin/mount.nfs 
chmod -f 0750 /sbin/mount.nfs4
chmod -f 0700 /usr/bin/ldd #0400 FOR SOME SYSTEMS
chmod -f 0700 /bin/traceroute
chown -f root:root /bin/traceroute
chmod -f 0700 /usr/bin/traceroute6*
chown -f root:root /usr/bin/traceroute6
chmod -f 0700 /sbin/iptunnel
chmod -f 0700 /usr/bin/tracpath*	
chmod -f 0644 /dev/audio
chown -f root:root /dev/audio
chmod -f 0644 /etc/environment
chown -f root:root /etc/environment
chmod -f 0600 /etc/modprobe.conf
chown -f root:root /etc/modprobe.conf
chown -f root:root /etc/modprobe.d
chown -f root:root /etc/modprobe.d/*
chmod -f 0700 /etc/modprobe.d
chmod -f 0600 /etc/modprobe.d/*
chmod -f o-w /selinux/*
umask 077 /etc/*
chmod -f 0755 /etc
chmod -f 0644 /usr/share/man/man1/*
chmod -f 0600 /etc/yum.repos.d/*


#### CLAMAV SECURITY
if [[ -d /usr/local/share/clamav ]]; then
   passwd -l clamav 2>/dev/null
   usermod -s /sbin/nologin clamav 2>/dev/null
   chmod -f 0755 /usr/local/share/clamav
   chown -f root:clamav /usr/local/share/clamav
   chown -f root:clamav /usr/local/share/clamav/*.cvd
   chmod -f 0664 /usr/local/share/clamav/*.cvd
   mkdir -p /var/log/clamav
   chown -f root:$AUDIT /var/log/clamav
   chmod -f 0640 /var/log/clamav
fi
if [[ -d /var/clamav ]]; then
   passwd -l clamav 2>/dev/null
   usermod -s /sbin/nologin clamav 2>/dev/null
   chmod -f 0755 /var/clamav
   chown -f root:clamav /var/clamav
   chown -f root:clamav /var/clamav/*.cvd
   chmod -f 0664 /var/clamav/*.cvd
   mkdir -p /var/log/clamav
   chown -f root:$AUDIT /var/log/clamav
   chmod -f 0640 /var/log/clamav
fi


#### DISA STIG FILE OWNERSHIP
chmod -f 0755 /bin/csh
chmod -f 0755 /bin/jsh
chmod -f 0755 /bin/ksh
chmod -f 0755 /bin/rsh
chmod -f 0755 /bin/sh
chmod -f 0640 /dev/kmem
chown -f root:sys /dev/kmem
chmod -f 0640 /dev/mem
chown -f root:sys /dev/mem
chmod -f 0666 /dev/null
chown -f root:sys /dev/null
chmod -f 0755 /etc/csh
chmod -f 0755 /etc/jsh
chmod -f 0755 /etc/ksh
chmod -f 0755 /etc/rsh
chmod -f 0755 /etc/sh
chmod -f 0644 /etc/aliases
chown -f root:root /etc/aliases
chmod -f 0640 /etc/exports
chown -f root:root /etc/exports
chmod -f 0640 /etc/ftpusers
chown -f root:root /etc/ftpusers
chmod -f 0664 /etc/host.lpd
chmod -f 0440 /etc/inetd.conf
chown -f root:root /etc/inetd.conf
chmod -f 0644 /etc/mail/aliases
chown -f root:root /etc/mail/aliases
chmod -f 0644 /etc/passwd
chown -f root:root /etc/passwd
chmod -f 0400 /etc/shadow
chown -f root:root /etc/shadow
chmod -f 0600 /etc/uucp/L.cmds
chown -f uucp:uucp /etc/uucp/L.cmds
chmod -f 0600 /etc/uucp/L.sys
chown -f uucp:uucp /etc/uucp/L.sys
chmod -f 0600 /etc/uucp/Permissions
chown -f uucp:uucp /etc/uucp/Permissions
chmod -f 0600 /etc/uucp/remote.unknown
chown -f root:root /etc/uucp/remote.unknown
chmod -f 0600 /etc/uucp/remote.systems
chmod -f 0600 /etc/uccp/Systems
chown -f uucp:uucp /etc/uccp/Systems
chmod -f 0755 /sbin/csh
chmod -f 0755 /sbin/jsh
chmod -f 0755 /sbin/ksh
chmod -f 0755 /sbin/rsh
chmod -f 0755 /sbin/sh
chmod -f 0755 /usr/bin/csh
chmod -f 0755 /usr/bin/jsh
chmod -f 0755 /usr/bin/ksh
chmod -f 0755 /usr/bin/rsh
chmod -f 0755 /usr/bin/sh
chmod -f 1777 /var/mail
chmod -f 1777 /var/spool/uucppublic


#### SELINUX CONFIG
if [[ -f /etc/sysconfig/selinux ]]; then
   echo "SELINUX=disabled" > /etc/sysconfig/selinux
   echo "SELINUXTYPE=targeted" >> /etc/sysconfig/selinux
   chmod -f 0640 /etc/sysconfig/selinux
fi


#### DISABLE CTRL-ALT-DELETE RHEL 6+
if [[ -f /etc/init/control-alt-delete.conf ]]; then
   if [[ `grep ^exec /etc/init/control-alt-delete.conf` != "" ]]; then
	  sed -i 's/^exec/#exec/g' /etc/init/control-alt-delete.conf
   fi
fi


#### DISABLE CTRL-ALT-DELETE RHEL 5
if [[ -f /etc/inittab ]]; then
   if [[ `grep ^ca:: /etc/inittab` != "" ]]; then
	  sed -i 's/^ca::/#ca::/g' /etc/inittab
   fi
fi


#### REMOVE SECURITY RELATED PACKAGES
if [[ -f /bin/rpm ]]; then
   rpm -ev tcpdump 2>/dev/null
   rpm -ev nmap 2>/dev/null
   rpm -ev telnet-server 2>/dev/null
   rpm -ev --allmatches --nodeps wireless-tools 2>/dev/null
   rpm -ev vsftpd 2>/dev/null
   rpm -ev vnc-server 2>/dev/null
   rpm -ev wireshark 2>/dev/null
   rpm -ev tigervnc-server 2>/dev/null
fi

if [[ `which apt-get 2>/dev/null` != "" ]]; then
   apt-get autoremove -y netcat-openbsd
   apt-get autoremove -y ftp
   apt-get autoremove -y nmap
   apt-get autoremove -y telnet
   apt-get autoremove -y rdate
   apt-get autoremove -y ntpdate
   apt-get autoremove -y tcpdump
fi


#### ACCOUNT MANAGEMENT / CLEANUP
if [[ `which userdel 2>/dev/null` != "" ]]; then
   userdel -f games 2>/dev/null
   userdel -f news 2>/dev/null
   userdel -f gopher 2>/dev/null
   userdel -f tcpdump 2>/dev/null
   userdel -f shutdown 2>/dev/null
   userdel -f halt 2>/dev/null
#   userdel -f nobody 2>/dev/null
#   userdel -f nfsnobody 2>/dev/null
   userdel -f sync 2>/dev/null
   userdel -f ftp 2>/dev/null
   userdel -f operator 2>/dev/null
   userdel -f lp 2>/dev/null
   userdel -f uucp 2>/dev/null
   userdel -f irc 2>/dev/null
   userdel -f gnats 2>/dev/null
fi


#### GDM RHEL5 COMES UNLOCKED
passwd -l gdm 2>/dev/null


#if [[ `which chage 2>/dev/null` != "" ]]; then
#   chage -M $PASS_EXPIRE root
#   chage -d 1 root
#   chage -W 14 root
#fi


#### DISABLE FINGERPRINT IN PAM / AUTHCONFIG
if [[ `which authconfig 2>/dev/null` != "" ]]; then
   authconfig --disablefingerprint --update
fi


#### START-UP CHKCONFIG LEVELS SET
if [[ -f /sbin/chkconfig ]]; then
   /sbin/chkconfig --level 12345 auditd on 2>/dev/null
   #/sbin/chkconfig yum-updatesd off 2>/dev/null
   /sbin/chkconfig isdn off 2>/dev/null
   /sbin/chkconfig bluetooth off 2>/dev/null
   /sbin/chkconfig haldaemon off 2>/dev/null #NEEDED ON FOR RHEL6 GUI
fi


#### CHANGE MOUNT POINT SECURITY TO NODEV, NOEXEC, NOSUID ONLY TESTED ON RHEL
## /boot
#sed -i "s/\( \/boot.*`grep " \/boot " /etc/fstab | awk '{print $4}'`\)/\1,nodev,noexec,nosuid/" /etc/fstab

## /dev/shm
#sed -i "s/\( \/dev\/shm.*`grep " \/dev\/shm " /etc/fstab | awk '{print $4}'`\)/\1,nodev,noexec,nosuid/" /etc/fstab

## /var
#sed -i "s/\( \/var\/log.*`grep " \/var " /etc/fstab | awk '{print $4}'`\)/\1,nodev,noexec,nosuid/" /etc/fstab

## /var/log
#sed -i "s/\( \/var\/log.*`grep " \/var\/log " /etc/fstab | awk '{print $4}'`\)/\1,nodev,noexec,nosuid/" /etc/fstab

## /tmp
#sed -i "s/\( \/tmp.*`grep " \/tmp " /etc/fstab | awk '{print $4}'`\)/\1,nodev,noexec,nosuid/" /etc/fstab

## /home
#sed -i "s/\( \/home.*`grep " \/home " /etc/fstab | awk '{print $4}'`\)/\1,nodev,nosuid/" /etc/fstab


#### MISC SETTINGS / PERMISSIONS
chown -Rf root:users /usr/local/src/*
chmod -Rf o-w /usr/local/src/*
rm -f /etc/security/console.perms

#### REMOVE RPMNEW / RPMSAVE
rm -f /etc/audit/audit*old
if [[ `which rpm 2>/dev/null` != "" ]]; then
   find / -noleaf 2>/dev/null | grep -v '/net\|/proc' | grep '\.rpmsave'
   find / -noleaf 2>/dev/null | grep -v '/net\|/proc' | grep '\.rpmnew'
fi

#### SET BACKGROUND IMAGE PERMISSIONS
if [[ -d /usr/share/backgrounds ]]; then
   chmod -f 0444 /usr/share/backgrounds/default*
   chmod -f 0444 /usr/share/backgrounds/images/default*
fi


echo ""
echo "WARNING!WARNING!WARNING!"
echo "CHANGE ROOT'S PASSWORD AFTER RUNNING QUICK NIX SECURE SCRIPT, JUST IN CASE."
echo "WARNING!WARNING!WARNING!"
