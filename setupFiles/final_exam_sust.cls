\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{final_exam_sust}[2026/08/21 Optimized Custom Exam Class for SUST]

% Load base class
\LoadClass[legalpaper, 11pt, addpoints]{exam}

% --- Page Geometry & Layout ---
% Adjusted footskip to 1.2cm to push it slightly further down but keep it fully visible
\RequirePackage[top=0.8in, bottom=1.6cm, left=1in, right=1in, footskip=1.2cm]{geometry}
\RequirePackage{changepage}
\RequirePackage{multicol}
\RequirePackage{lastpage}

% --- Encoding & Fonts ---
\RequirePackage[utf8]{inputenc}
\RequirePackage[euler]{textgreek}

% --- Date & Time ---
\RequirePackage[showzone=false, showseconds=false]{datetime2}
\RequirePackage{advdate}

% --- Math Packages ---
\RequirePackage{amsmath}
\RequirePackage{mathtools} % Modern extension to amsmath
\RequirePackage{amssymb}
\RequirePackage{xfrac}

% --- Physics & SI Units ---
\RequirePackage{physics}   
\RequirePackage{siunitx}   

% Suppress siunitx physics notice & alias \qty to \SI
\ExplSyntaxOn
\msg_redirect_name:nnn { siunitx } { physics-pkg } { none }
\ExplSyntaxOff
\AtBeginDocument{\RenewCommandCopy\qty\SI}

% --- Chemistry Packages ---
\RequirePackage{chemfig}   % Molecular structure drawing
\RequirePackage[version=4]{mhchem} % Modern chemical equations typesetting

% --- Graphics & Plots ---
\RequirePackage{graphicx}
\RequirePackage{caption}
\RequirePackage{subfig}
\RequirePackage{float}
\RequirePackage{tikz}
\RequirePackage{pgfplots}
\RequirePackage{circuitikz}

\usetikzlibrary{decorations.pathreplacing}
\pgfplotsset{compat=1.18} % Recommended pgfplots compatibility setting

% --- Tables ---
\RequirePackage{tabularx}
\RequirePackage{multirow}

% --- Lists & Formatting ---
\RequirePackage{enumitem}  % Clean list customization

% --- Code & Verbatim ---
\RequirePackage{listings}
\RequirePackage{fancyvrb}
\RequirePackage{verbatim}

% --- String Utilities ---
\RequirePackage{xstring}

% --- Settings & Configurations ---
\graphicspath{{Figures/}}
\captionsetup{figurename=Fig.}
\renewcommand{\thesubfigure}{\roman{subfigure}}

% Listings formatting for appendix
\lstset{
    language=C,
    basicstyle=\footnotesize\ttfamily,
    numbers=left,
    stepnumber=1,
    showstringspaces=false,
    tabsize=2,
    breaklines=true,
    breakatwhitespace=false
}

% Exam page footer setup
\footer
  {\tiny \teacherUniqueID}                      % Left
  {\tiny \examDate{}}                          % Center
  {\tiny Page \thepage\ of \pageref{LastPage}} % Right

% Exam package overrides
\renewcommand{\subpartlabel}{(\thesubpart)}

% Custom inline subparts list
\newlist{inlinesubparts}{enumerate*}{1}
\setlist[inlinesubparts]{label=(\roman*), itemjoin={{, }}, itemjoin*={{, and }}}

% Points format in right margin
\pointsinrightmargin
\pointname{}
\pointformat{\thepoints}

% Command for breakdown parts without total point
\newcommand{\bdpart}[1][]{%
  \IfSubStr{#1}{+}{%
    \pointformat{#1}%
    \part[0]%
    \pointformat{\thepoints}%
  }{%
    \part[#1]%
  }%
}