# Manages GRUB2 Users - Does not apply to GRUB Legacy
#
# Author Trevor Vaughan <tvaughan@onyxpoint.com>
# Copyright (c) 2015 Onyx Point, Inc.

Puppet::Type.newtype(:grub_user) do
  @doc = <<-EOM
    Manages GRUB2 Users - Does not apply to GRUB Legacy

    Note: This type compares against the *active* GRUB configuration. The
    contents of the management file will not be updated unless the active
    configuration is out of sync with the expected configuration.
  EOM

  feature :grub2, 'Management of GRUB2 resources'

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name) do
    desc <<-EOM
      The username of the GRUB2 user to be managed.
    EOM

    isnamevar

    validate do |value|
      # These are items that can separate users in the superusers string and,
      # therefore, should not be valid as a username.
      if value =~ /\s|,|;|&|\|/
        raise(Puppet::ParseError, "Usernames may not contain spaces, commas, semicolons, ampersands, or pipes")
      end
    end
  end

  newparam(:superuser, :boolean => true) do
    desc <<-EOM
      If set, add this user to the 'superusers' list, if no superusers are set,
      but grub_user resources have been declared, a compile error will be
      raised.
    EOM

    newvalues(:true, :false)

    defaultto(:false)
  end

  newparam(:target) do
    desc <<-EOM
      The file to which to write the user information.

      Must be an absolute path.
    EOM

    newvalues(/^\/.+/)
    defaultto('/etc/grub.d/01_puppet_managed_users')
  end

  newparam(:grub2_cfg, :parent => Puppet::Parameter::Path) do
    desc <<-EOM
      The location of the target 'grub2.cfg' file on the system.

      By default, the system attempts to autodiscover the location on the
      system.

      EFI locations are searched first followed by standard grub2.cfg locations.
    EOM
  end

  newparam(:report_unmanaged, :boolean => true) do
    desc <<-EOM
      Report any unmanaged users as a warning during the Puppet run.
    EOM

    newvalues(:true, :false)
    defaultto(:false)
  end

  newparam(:rounds) do
    desc <<-EOM
      The rounds to use when hashing the password.
    EOM

    newvalues(/^\d+$/)
    defaultto(10000)

    munge do |value|
      value.to_i
    end
  end

  newproperty(:purge, :boolean => true) do
    desc <<-EOM
      Purge all unmanaged users.

      This does not affect any users that are not defined by Puppet! There is
      no way to reliably eliminate the items from all other scripts without
      potentially severely damaging the GRUB2 build scripts.
    EOM

    newvalues(:true, :false)
    defaultto(:false)
  end

  newproperty(:password) do
    desc <<-EOM
      The user's password. If the password is not already in a GRUB2 compatible
      form, it will be automatically converted.
    EOM

    validate do |value|
      raise(Puppet::ParseError, "Passwords must be Strings") unless value.is_a?(String)
    end

    def insync?(is)
      provider.password?(is,should)
    end
  end
end
