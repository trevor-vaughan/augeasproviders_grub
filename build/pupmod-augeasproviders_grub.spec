%define mod_name augeasproviders_grub

Summary: Grub Augeas-based providers for Puppet
Name: pupmod-augeasproviders_grub
Version: 2.3.1
Release: 0
License: Apache License, 2.0
Group: Applications/System
URL: https://github.com/hercules-team/%{mod_name}
Source: %{name}-%{version}-%{release}.tar.gz
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Buildarch: noarch
Requires: pupmod-augeasproviders_core >= 2.0.1
Requires: simp-bootstrap >= 4.2.0
Requires: puppet

Prefix: %{_sysconfdir}/puppet/environments/simp/modules

%description
This module provides types/providers for grub configuration files using the
Augeas configuration API library.

%prep
%setup -q

%build

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/%{mod_name}

dirs='files lib manifests templates'
for dir in $dirs; do
  test -d $dir && cp -r $dir %{buildroot}/%{prefix}/%{mod_name}
done

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/%{mod_name}

%files
%defattr(0640,root,puppet,0750)
%{prefix}/%{mod_name}

%post
#!/bin/sh

%postun
# Post uninstall stuff

%changelog
* Thu Mar 03 2016 Trevor Vvaughan <tvaughan@onyxpoint.com> - 2.3.1-0
- Rebase on the upstream release

* Wed Feb 24 2016 Trevor Vaughan <tvaughan@onyxpoint.com> - 2.0.1-1
- Added 3 new providers for managing GRUB and GRUB2 menuentries, global values,
  and users.

* Wed Feb 18 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 2.0.1-0
- First release of %{mod_name} from Team Hercules
