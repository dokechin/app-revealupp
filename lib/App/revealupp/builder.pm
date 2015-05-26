package App::revealupp::builder;
use App::revealupp::base;
use App::revealupp::util;
use Path::Tiny qw/path/;
use Text::MicroTemplate qw/render_mt/;

has 'theme';
has 'theme_path';
has 'transition' => 'default';
has 'width' => 960;
has 'height' => 700;
has 'lang' => 'en-us';
has 'filename';

sub build_html {
    my $self = shift;
    if ( !$self->filename || !path($self->filename)->exists ){
        return;
    }
    if($self->theme) {
        if ($self->theme !~ m!.+\.css$!){
            my $name = $self->theme() . '.css';
            $self->theme( $name );
        }
        my $p = path('.', $self->theme);
        if(!$p->exists) {
            $p = path('revealjs','css','theme',$self->theme);
            $self->theme_path($p);
        }
        $self->theme_path($p);
    }
    my $html = $self->render($self->filename);
    return $html;
}

sub render {
    my ($self, $filename) = @_;
    my $template_dir = App::revealupp::util::share_path([qw/share templates/]);
    my $template = $template_dir->child('slide.html.mt');
    my $content = $template->slurp_utf8();
    my $html = render_mt(
        $content,
        $filename,
        $self->theme_path,
        $self->transition,
        { width => $self->width, height => $self->height},
        $self->lang,
    )->as_string();
    return $html;
}

1;
