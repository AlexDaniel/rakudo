use Perl6::Metamodel;

proto trait_mod:<is>(|$) { * }
multi trait_mod:<is>(Mu:U $child, Mu:U $parent) {
    $child.HOW.add_parent($child, $parent);
}
multi trait_mod:<is>(Attribute:D $attr, :$rw!) {
    $attr.set_rw();
}

multi trait_mod:<is>(Routine:D $r, :$rw!) {
}

multi trait_mod:<is>(Parameter:D $param, :$rw!) {
    $param.set_rw();
}
multi trait_mod:<is>(Parameter:D $param, :$copy!) {
    $param.set_copy();
}

# TODO: Make this much less cheaty. That'll probably need the
# full-blown serialization, though.
multi trait_mod:<is>(Routine:D \$r, :$export!) {
    if $*COMPILING {
        my @tags = 'ALL', 'DEFAULT';
        for @tags -> $tag {
            my $install_in;
            if $*EXPORT.WHO.exists($tag) {
                $install_in := $*EXPORT.WHO.{$tag};
            }
            else {
                $install_in := $*ST.pkg_create_mo((package { }).HOW.WHAT, :name($tag));
                $*ST.pkg_compose($install_in);
                $*ST.install_package_symbol($*EXPORT, $tag, $install_in);
            }
            $*ST.install_package_symbol($install_in, '&' ~ $r.name, $r);
        }
    }
}

proto trait_mod:<does>(|$) { * }
multi trait_mod:<does>(Mu:U $doee, Mu:U $role) {
    $doee.HOW.add_role($doee, $role)
}

proto trait_mod:<of>(|$) { * }
multi trait_mod:<of>(Mu:U $target, Mu:U $type) {
    # XXX Ensure we can do this, die if not.
    $target.HOW.set_of($target, $type);
}

proto trait_mod:<as>(|$) { * }
multi trait_mod:<as>(Parameter:D $param, $type) {
    # XXX TODO
}

proto trait_mod:<will>(|$) { * }
multi trait_mod:<will>(Attribute $attr, Block $closure, :$build!) {
    $attr.set_build_closure($closure)
}
