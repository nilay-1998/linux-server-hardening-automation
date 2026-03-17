#!/bin/bash
# ============================================================
# user_management.sh
# Automated user creation, deletion, and permission management
# Author: Nilay Meshram | github.com/nilay-1998
# ============================================================

ACTION=$1
USERNAME=$2
GROUP=$3

if [ -z "$ACTION" ] || [ -z "$USERNAME" ]; then
  echo "Usage: $0 {create|delete|permissions} username [group]"
  exit 1
fi

case $ACTION in
  create)
    if id "$USERNAME" &>/dev/null; then
      echo "User $USERNAME already exists."
      exit 1
    fi
    useradd -m -s /bin/bash "$USERNAME"
    echo "User $USERNAME created."

    if [ -n "$GROUP" ]; then
      usermod -aG "$GROUP" "$USERNAME"
      echo "User $USERNAME added to group $GROUP."
    fi

    chage -d 0 "$USERNAME"  # Force password reset on first login
    echo "Password expiry set. User must reset on first login."
    ;;

  delete)
    if ! id "$USERNAME" &>/dev/null; then
      echo "User $USERNAME does not exist."
      exit 1
    fi
    userdel -r "$USERNAME"
    echo "User $USERNAME and home directory deleted."
    ;;

  permissions)
    if ! id "$USERNAME" &>/dev/null; then
      echo "User $USERNAME does not exist."
      exit 1
    fi
    chmod 750 /home/"$USERNAME"
    setfacl -m u:"$USERNAME":rwx /home/"$USERNAME"
    echo "Permissions updated for $USERNAME."
    ;;

  *)
    echo "Invalid action: $ACTION"
    echo "Usage: $0 {create|delete|permissions} username [group]"
    exit 1
    ;;
esac
