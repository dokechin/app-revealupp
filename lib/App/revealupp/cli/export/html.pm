package App::revealupp::cli::export::html;
use App::revealupp::base;
use App::revealupp::util;
use App::revealupp::builder;
use Path::Tiny qw/path/;
use Term::ANSIColor;
use Pod::Usage;

has 'theme';
has 'transition';
has 'width';
has 'height';
has 'lang';
has 'output' => 'original.html';

sub run {
    my ($self, @args) = @_;
    my $opt;
    parse_options(
        \@args,
        'theme=s' => \$opt->{theme},
        'transition=s' => \$opt->{transition},
        'width=i' => \$opt->{width},
        'height=i' => \$opt->{height},
        'output=s' => \$opt->{output},
        'lang=s' => \$opt->{lang},
    );
    for my $key (keys %$opt) {
        $self->$key( $opt->{$key} );
    }

    if (path($self->output)->exists) {
        App::revealupp::util::error("@{[$self->output]} exists");
    }

    my $filename = shift @args;
    if (!path($filename)->exists) {
        App::revealupp::util::error("$filename is not exist");
    }
    
    my $builder = App::revealupp::builder->new(
        filename => $filename || '',
        theme => $self->theme || '',
        transition => $self->transition || '',
        width => $self->width || 0,
        height => $self->height || 0,
        lang => $self->lang || 'en-us',
    );
    
    my $html = $builder->build_html();
    die if !$html;
    path($self->output)->spew_utf8($html);
    App::revealupp::util::info("Generated your HTML to @{[$self->output]}");
    my $reveal_path = App::revealupp::util::share_path([qw/share revealjs/]);
    my $notes_speech_path = App::revealupp::util::share_path([qw/share notes-speech/]);
    App::revealupp::util::info("Copy command for the revealjs directory is:");
    App::revealupp::util::info("cp -r @{[$reveal_path->absolute]} ./revealjs");
    App::revealupp::util::info("cp -r @{[$notes_speech_path->absolute]} ./notes-speech");
}

1;
