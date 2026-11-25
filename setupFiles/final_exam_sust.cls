\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{final_exam_sust}[2026/08/21 Combined and Optimized Custom Exam Class for SUST]

%% ========================================================================
%% 1. BASE CLASS & LAYOUT
%% ========================================================================

% Inherit from the standard 'exam' class. 
% - legalpaper: Sets paper size to legal.
% - 11pt: Default font size.
% - addpoints: Enables point calculation for the grading table.
\LoadClass[legalpaper, 11pt, addpoints]{exam}

% Page Geometry: Sets margins and ensures the footer is visible but pushed down.
\RequirePackage[top=0.8in, bottom=1.6cm, left=1in, right=1in, footskip=1.2cm]{geometry}
\RequirePackage{changepage} % Allows local margin changes (e.g., adjustwidth)
\RequirePackage{multicol}   % Enables multi-column layouts for compact questions
\RequirePackage{lastpage}   % Allows referencing the total number of pages

%% ========================================================================
%% 2. ENCODING, FONTS, & STRINGS
%% ========================================================================

\RequirePackage[utf8]{inputenc}   % Standard UTF-8 encoding
\RequirePackage[euler]{textgreek} % Allows non-italic Greek letters in text mode
\RequirePackage{xstring}          % String manipulation utilities (used in custom macros)

%% ========================================================================
%% 3. DATE & TIME UTILITIES
%% ========================================================================

\RequirePackage[showzone=false, showseconds=false]{datetime2}
\RequirePackage{advdate} % Allows relative date calculations (e.g., "tomorrow")

%% ========================================================================
%% 4. MATH, PHYSICS & CHEMISTRY
%% ========================================================================

% Standard Math Packages
\RequirePackage{amsmath}
\RequirePackage{mathtools} % Extension to amsmath (fixes bugs, adds tools)
\RequirePackage{amssymb}   % Mathematical symbols (including \checkmark)
\RequirePackage{xfrac}     % Enables slanted fractions (\sfrac)
\RequirePackage{bm}        % Access to bold math symbols (e.g., vectors and matrices)




% Physics & Units
\RequirePackage{physics}   % Macros for derivatives, matrices, bras/kets
\RequirePackage{siunitx}   % Standardized SI unit formatting (\SI or \qty)

% Fix for siunitx & physics package conflict:
% Suppresses the warning and explicitly aliases \qty to \SI to ensure compatibility
\ExplSyntaxOn
\msg_redirect_name:nnn { siunitx } { physics-pkg } { none }
\ExplSyntaxOff
\AtBeginDocument{\RenewCommandCopy\qty\SI}

% Chemistry
\RequirePackage{chemfig}           % Drawing 2D chemical structures
\RequirePackage[version=4]{mhchem} % Typesetting chemical formulas (e.g., \ce{H2O})

%% ========================================================================
%% 5. GRAPHICS, FIGURES & TABLES
%% ========================================================================

\RequirePackage{graphicx}   % Image inclusion
\RequirePackage{caption}    % Customizing caption formats
\RequirePackage{subcaption} % Modern package for subfigures (replaces subfig)
\RequirePackage{float}      % Enforces strict figure placement (H modifier)

% TikZ & Plotting Settings
\RequirePackage{tikz}
\RequirePackage{pgfplots}
\RequirePackage{circuitikz} % Electrical circuit drawing
\usetikzlibrary{decorations.pathreplacing} % For curly braces in TikZ
\usetikzlibrary{circuits.logic.US}         % Logic gates for circuits
\pgfplotsset{compat=1.18}                  % Ensures consistent plot compilation

% Table Packages
\RequirePackage{tabularx}  % Tables that stretch to a specified width
\RequirePackage{multirow}  % Allows cells to span multiple rows
\RequirePackage{array}     % Advanced column formatting
\RequirePackage{spreadtab} % Spreadsheet-like features for tables

% Graphics Path & Caption Formatting
\graphicspath{{Figures/}}                      % Default folder for \includegraphics
\captionsetup{figurename=Fig.}                 % Rename "Figure 1" to "Fig. 1"
\captionsetup[subfigure]{labelformat=simple, labelsep=space}
\renewcommand{\thesubfigure}{\roman{subfigure}}% Subfigures use roman numerals (i)

%% ========================================================================
%% 6. CODE LISTINGS & VERBATIM
%% ========================================================================

\RequirePackage{listings}
\RequirePackage{fancyvrb}
\RequirePackage{verbatim}

% Default style for code blocks (e.g., C programming)
\lstset{
    language=C,
    basicstyle=\footnotesize\ttfamily, % Small typewriter font
    numbers=left,                      % Line numbers on the left
    stepnumber=1,
    showstringspaces=false,            % Don't show underscores for spaces in strings
    tabsize=2,
    breaklines=true,                   % Auto-wrap long lines
    breakatwhitespace=false
}

%% ========================================================================
%% 7. EXAM CLASS CUSTOMIZATIONS (HEADERS, FOOTERS, POINTS)
%% ========================================================================

% --- TOS Conditional Switch Declaration ---
% Declares a switch globally to conditionally print the Table of Specifications (TOS)
\newif\ifprintTOS

% --- TOS automatic totals (no Python needed) ---
% In TexFiles/tos.tex write each row as
%   \tosrow{Q.No.}{Marks}{CO}{Remember}{Understand}{Apply}{Analyze}{Evaluate}{Create}
% (leave a level empty, e.g. {}, if it has no marks), use \tosgap for an empty
% spacer row, and put \tostotals just before \end{tabular}. The Total row, the
% "% in each level" row and the "% Marks in Major levels" row are computed
% automatically at compile time. A warning is written to the log if a row's
% Marks value differs from the sum of its Bloom-level marks.
\ExplSyntaxOn
\fp_new:N \g__tos_marks_fp
\fp_new:N \g__tos_bloom_fp
\fp_new:N \g__tos_i_fp \fp_new:N \g__tos_ii_fp \fp_new:N \g__tos_iii_fp
\fp_new:N \g__tos_iv_fp \fp_new:N \g__tos_v_fp \fp_new:N \g__tos_vi_fp
\fp_new:N \l__tos_row_fp
\cs_new_protected:Npn \__tos_add:Nn #1#2
  {
    \tl_if_blank:nF {#2}
      {
        \fp_gadd:Nn #1 {#2}
        \fp_gadd:Nn \g__tos_bloom_fp {#2}
        \fp_add:Nn \l__tos_row_fp {#2}
      }
  }
\cs_new_protected:Npn \__tos_accumulate:nnnnnnnn #1#2#3#4#5#6#7#8
  {
    \fp_zero:N \l__tos_row_fp
    \tl_if_blank:nF {#2} { \fp_gadd:Nn \g__tos_marks_fp {#2} }
    \__tos_add:Nn \g__tos_i_fp   {#3}
    \__tos_add:Nn \g__tos_ii_fp  {#4}
    \__tos_add:Nn \g__tos_iii_fp {#5}
    \__tos_add:Nn \g__tos_iv_fp  {#6}
    \__tos_add:Nn \g__tos_v_fp   {#7}
    \__tos_add:Nn \g__tos_vi_fp  {#8}
    \tl_if_blank:nF {#2}
      {
        \fp_compare:nNnF { \l__tos_row_fp } = {#2}
          {
            \use:e
              {
                \exp_not:N \msg_warning:nnnnn { final_exam_sust } { tos-mismatch }
                  { \tl_trim_spaces:n {#1} } { \tl_trim_spaces:n {#2} }
                  { \fp_use:N \l__tos_row_fp }
              }
          }
      }
  }
\msg_new:nnn { final_exam_sust } { tos-mismatch }
  { TOS~row~'#1':~Marks~=~#2~but~Bloom~levels~add~up~to~#3. }
% Expandable helpers used inside \tostotals
\cs_new:Npn \__tos_pct:N #1
  {
    \fp_compare:nNnTF { \g__tos_bloom_fp } > { 0 }
      { \fp_eval:n { 100 * #1 / \g__tos_bloom_fp } } { 0 }
  }
\cs_new:Npn \__tos_major_i:
  { \fp_eval:n { \g__tos_i_fp + \g__tos_ii_fp + \g__tos_iii_fp } }
\cs_new:Npn \__tos_major_ii:
  { \fp_eval:n { \g__tos_iv_fp + \g__tos_v_fp + \g__tos_vi_fp } }
\cs_new_eq:NN \tos@accumulate \__tos_accumulate:nnnnnnnn
\cs_new:Npn \tos@val #1 { \fp_use:c { g__tos_#1_fp } }
\cs_new:Npn \tos@pct #1 { \exp_args:Nc \__tos_pct:N { g__tos_#1_fp } }
\cs_new:Npn \tos@majorI  { \__tos_pct:N \__tos_major_i: }
\cs_new:Npn \tos@majorII { \__tos_pct:N \__tos_major_ii: }
% Expandable "two decimals" formatter, e.g. 20 -> 20.00, 8.333 -> 8.33
\cs_new:Npn \tos@fmtpct #1
  { \exp_args:Ne \__tos_fmt:n { \fp_eval:n { round(#1, 2) } } }
\cs_new:Npn \__tos_fmt:n #1
  {
    \fp_eval:n { trunc(#1) } .
    \int_compare:nNnT { \fp_eval:n { round((#1 - trunc(#1)) * 100) } } < { 10 } { 0 }
    \fp_eval:n { round((#1 - trunc(#1)) * 100) }
  }
\ExplSyntaxOff
\makeatletter

% One data row of the TOS table
\newcommand{\tosrow}[9]{%
  #1 & #2 & #3 & #4 & #5 & #6 & #7 & #8 & #9%
  \tos@accumulate{#1}{#2}{#4}{#5}{#6}{#7}{#8}{#9}%
  \\ \hline}
% An empty spacer row
\newcommand{\tosgap}{ & & & & & & & & \\ \hline}
% The three automatically calculated summary rows
\newcommand{\tostotals}{%
  \textbf{Total} & \textbf{\tos@val{marks}} & &
    \textbf{\tos@val{i}} & \textbf{\tos@val{ii}} & \textbf{\tos@val{iii}} &
    \textbf{\tos@val{iv}} & \textbf{\tos@val{v}} & \textbf{\tos@val{vi}} \\ \hline
  \multicolumn{3}{|c|}{\textbf{Total \% in each level}} &
    \textbf{\tos@fmtpct{\tos@pct{i}}} & \textbf{\tos@fmtpct{\tos@pct{ii}}} &
    \textbf{\tos@fmtpct{\tos@pct{iii}}} & \textbf{\tos@fmtpct{\tos@pct{iv}}} &
    \textbf{\tos@fmtpct{\tos@pct{v}}} & \textbf{\tos@fmtpct{\tos@pct{vi}}} \\ \hline
  \multicolumn{3}{|c|}{\textbf{\% Marks in Major levels}} &
    \multicolumn{3}{c|}{\textbf{\tos@fmtpct{\tos@majorI}}} &
    \multicolumn{3}{c|}{\textbf{\tos@fmtpct{\tos@majorII}}} \\ \hline}
\makeatother

% Custom Footer Layout
\footer
  {\tiny \teacherUniqueID} % Left: Teacher ID (must be defined in main tex)
  {\tiny \examDate{}}      % Center: Exam Date (must be defined in main tex)
  {\tiny Page \thepage\ of % Right: Page X of Y (Adapts based on TOS presence)
     \ifprintTOS
       \pageref{endofquestions}% Uses label total if TOS is attached at the end
     \else
       \numpages % Standard total pages if no TOS
     \fi
  }

% List customization for inline subparts (e.g., (i), (ii), (iii) on one line)
\RequirePackage{enumitem}  
\newlist{inlinesubparts}{enumerate*}{1}
\setlist[inlinesubparts]{label=(\roman*), itemjoin={{, }}, itemjoin*={{, and }}}

% Override standard exam class formats
\renewcommand{\subpartlabel}{(\thesubpart)} % Format subparts as (i), (ii), etc.

% Point display formatting (Points displayed in the right margin)
\pointsinrightmargin
\pointname{}
\pointformat{\thepoints}

% Custom Macro: \bdpart (Breakdown Part)
% Allows assigning partial points within a question without adding to the total points.
% Usage: \bdpart[2] for standard points, or \bdpart[+2] for breakdown points.
\newcommand{\bdpart}[1][]{%
  \IfSubStr{#1}{+}{% Check if the argument contains a '+'
    \pointformat{#1}% Temporarily change point format to show the '+'
    \part[0]% Treat as 0 points logically so it doesn't double-count
    \pointformat{\thepoints}% Restore original point format
  }{%
    \part[#1]% Normal part if no '+' is present
  }%
}

%% ========================================================================
%% 8. MCQ CHECKBOX CUSTOMIZATION (ROMAN NUMERALS)
%% ========================================================================

% Macro to draw a small, uniform circular node containing text
\newcommand{\circledroman}[1]{%
  \tikz[baseline=(char.base)]{%
    \node[shape=circle, draw, inner sep=0.5pt, minimum size=10pt] (char) {\rmfamily\tiny #1};%
  }%
}

% 1. Format for a standard, unselected choice (Thin black circle)
\renewcommand{\checkboxchar}{\circledroman{\roman{choice}}}

% 2. Format for a correct choice when \printanswers is enabled (Thick red circle)
\renewcommand{\checkedchar}{\tikz[baseline=(char.base)]{%
  \node[shape=circle, draw=red, ultra thick, text=black, inner sep=0.5pt, minimum size=10pt] (char) {\rmfamily\tiny\textbf{\roman{choice}}};%
}}

% Internal modifications to force the exam class to step the 'choice' counter
\makeatletter

% --- VERTICAL CHECKBOXES FIX ---
% Determine how \CorrectChoice behaves based on whether \printanswers is active
\def\do@checkbox@correct{%
  \stepcounter{choice}% Force the counter to increment
  \ifprintanswers
    \item[\checkedchar]% Display the red circled answer for the answer key
  \else
    \item[\checkboxchar]% Display the normal black circle for the student exam
  \fi
  \do@choice@pageinfo
}

% Redefine the checkboxes environment to properly map \choice and \CorrectChoice
\renewenvironment{checkboxes}%
  {\list{\checkboxchar}%
     {\usecounter{choice}% Activate the 'choice' counter
      \def\makelabel##1{\hss\llap{##1}}%
      \settowidth{\leftmargin}{\checkboxchar\hskip\labelsep}%
      \labelwidth\leftmargin\advance\labelwidth-\labelsep
      \def\choice{\item}% Link \choice to standard \item
      \def\CorrectChoice{\do@checkbox@correct}% Link \CorrectChoice to our custom logic
      \topsep=0pt
      \partopsep=0pt
      \itemsep=0pt
     }%
  }%
  {\endlist}

% --- INLINE CHECKBOXES FIX (oneparcheckboxes) ---
\def\do@oneparcheckbox@choice{%
  \stepcounter{choice}% Force the counter to increment for inline choices
  \if@first@choice
    \@first@choicefalse
  \else
    \unskip\hskip 1em plus .5em minus .4em\relax
  \fi
  \checkboxchar\ \do@choice@pageinfo
}

\def\do@oneparcheckbox@correctchoice{%
  \stepcounter{choice}% Force the counter to increment for inline choices
  \if@first@choice
    \@first@choicefalse
  \else
    \unskip\hskip 1em plus .5em minus .4em\relax
  \fi
  \ifprintanswers
    \checkedchar\ % Print the thick red circle if answers are enabled
  \else
    \checkboxchar\ % Print the standard thin black circle for students
  \fi
  \do@choice@pageinfo
}

% Redefine the oneparcheckboxes environment with customizable spacing
\renewenvironment{oneparcheckboxes}%
  {%
    \setcounter{choice}{0}% Reset choice counter
    \def\choice{%
      \ifnum\value{choice}>0 \hskip 2.5em plus 1em minus 0.5em\fi % Space before choices 2, 3, 4...
      \stepcounter{choice}%
      \ignorespaces \checkboxchar \space
    }%
    \def\CorrectChoice{%
      \ifnum\value{choice}>0 \hskip 2.5em plus 1em minus 0.5em\fi % Space before choices 2, 3, 4...
      \stepcounter{choice}%
      \ignorespaces
      \ifprintanswers \checkedchar \else \checkboxchar \fi \space
    }%
    \ignorespaces
  }%
  {\ignorespacesafterend}

\makeatother