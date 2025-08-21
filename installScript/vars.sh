#!/bin/bash
################################################################################
# SET INTERNAL VARIABLE
################################################################################

# Exit codes
ERR_OK="0"  		         # No error (normal exit)
ERR_NOBKPDIR="1"  	     # No backup directory could be found
ERR_NOROOT="2"  		     # Running without root privileges
ERR_DEPNOTFOUND="3"  	   # Missing dependency
ERR_NO_CONNECTION="4"    # Missing connection to install packages
ERR_CREATE_USER="5"      # Can't create the user for some reason

# CMBACKUP INSTALLATION PATH
MYDIR=`dirname $0`                       # The directory where the install script is
ZMBKP_SRC="/usr/local/bin"               # The main script stay here
ZMBKP_CONF="/etc/cmbackup"               # The config/blocked list directory
ZMBKP_SHARE="/usr/local/share/cmbackup"  # Keep for upgrade routine
ZMBKP_LIB="/usr/local/lib/cmbackup"      # The new path for the libs

# ZIMBRA DEFAULT INSTALLATION PATH AND INTERNAL CONFIGURATION
OSE_USER="zextras"                                                                                                                             # Carbonio's unix user
OSE_INSTALL_DIR="/opt/zextras"                                                                                                                 # The Carbonio's installation path
OSE_DEFAULT_BKP_DIR="/opt/zextras/backup"                                                                                                      # Where you will store your backup
OSE_INSTALL_DOMAIN=`su -s /bin/bash -c "$OSE_INSTALL_DIR/bin/zmprov gad | head -1" $OSE_USER`                                                  # Carbonio's Domain
OSE_INSTALL_HOSTNAME=`hostname --fqdn`
OSE_INSTALL_PORT=`grep -A1 zimbraAdminPort $OSE_INSTALL_DIR/conf/attrs/attrs.xml | grep globalConfigValue | grep -v zimbraAdminPort | cut -d\> -f2 | cut -d\< -f1`
OSE_INSTALL_ADDRESS=`ping -c1 $OSE_INSTALL_HOSTNAME | head -1 | cut -d" " -f3|sed 's#(##g'|sed 's#)##g'`                                       # Carbonio's Server Address
OSE_INSTALL_LDAPPASS=`su -s /bin/bash -c "$OSE_INSTALL_DIR/bin/zmlocalconfig -s zimbra_ldap_password" $OSE_USER |awk '{print $3}'`             # Carbonio's LDAP Password
ZMBKP_MAIL_ALERT="zextras@"$OSE_INSTALL_DOMAIN                                                                                                   # Cmbackup's mail alert account
MAX_PARALLEL_PROCESS="3"                                                                                                                       # Cmbackup's number of threads
ROTATE_TIME="30"                                                                                                                               # Cmbackup's max of days before housekeeper
LOCK_BACKUP=true                                                                                                                               # Cmbackup's backup lock
ZMBKP_VERSION="cmbackup version: 1.2.6"                                                                                                        # Cmbackup's latest version
SESSION_TYPE="TXT"                                                                                                                             # Cmbackup's default session type

# REPOSITORIES FOR PACKAGES
OLE_TANGE="http://download.opensuse.org/repositories/home:/tange/CentOS_CentOS-6/home:tange.repo"

# Force a terminal type - Issue #90
export TERM="linux"
