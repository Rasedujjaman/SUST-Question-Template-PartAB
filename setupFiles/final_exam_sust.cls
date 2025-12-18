\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{final_exam_sust}
\LoadClass[legalpaper,11pt,addpoints]{exam} % addpoints is required

%\RequirePackage[margin = 2cm]{geometry}
\RequirePackage[top=0.5in, bottom=1.6cm, left=1in, right= 1in]{geometry}


%\RequirePackage{pageslts}
\RequirePackage{advdate}
\RequirePackage{verbatim}
\RequirePackage[latin1]{inputenc}
\RequirePackage{tikz}
\RequirePackage{float}
\RequirePackage{fancyvrb}
\RequirePackage{changepage}

\RequirePackage{circuitikz} %% To draw electric circuit diagram
\RequirePackage{multirow}
\RequirePackage{pgfplots}
\RequirePackage{multicol}
\RequirePackage{graphicx}
\RequirePackage{caption}
%\RequirePackage{subcaption}
\RequirePackage{subfig}
\RequirePackage{amsmath}
\RequirePackage[]{enumerate}
\RequirePackage{latexsym}
\RequirePackage{enumitem}
\RequirePackage{float}
%\usepackage{wrapfig}
\RequirePackage{caption}
\RequirePackage{siunitx}
\RequirePackage{listings} %For code in appendix
\RequirePackage{xfrac}
\RequirePackage{physics}
\RequirePackage{lastpage}	
\RequirePackage[euler]{textgreek}
\RequirePackage{pgfplots}
\RequirePackage{xstring}


\RequirePackage{tabularx}

\graphicspath{{Figures/}}
\lstset
{ %Formatting for code in appendix
	language=c,
	basicstyle=\footnotesize,
	numbers=left,
	stepnumber=1,
	showstringspaces=false,
	tabsize=1,
	breaklines=true,
	breakatwhitespace=false,
}



%%%%% To work on chemisty formula and structure 
% Using chemfig to draw molecules (structural formulae)
\RequirePackage{chemfig} 

%Using mhchem to typeset chemical formulae and equations
%Load mhchem using some package options
\RequirePackage[version=4,arrows=pgf-filled,
textfontname=sffamily,
mathfontname=mathsf]{mhchem}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





\renewcommand{\thesubfigure}{\roman{subfigure}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\footer
  %{\textit{\tiny {\deptNameShort{},~\institutionNameShort{}}}} % Left
  {\textit{\tiny {\teacherUniqueID}}} 							% Left
  {\textit{\tiny \examDate{}}}                                  % Center
  {\textit{\tiny Page \thepage\ of \pageref{LastPage}}}         % Right




\usetikzlibrary{decorations.pathreplacing}
\captionsetup{figurename=Fig.}





\renewcommand{\subpartlabel}{(\thesubpart)}  % wrap it in parentheses, no dot

% Define an inline subparts environment
\newlist{inlinesubparts}{enumerate*}{1}
\setlist[inlinesubparts]{label=(\roman*), itemjoin={{, }}, itemjoin*={{, and }}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% About displaying the marks
% Show points in right margin
\pointsinrightmargin
\pointname{}
\pointformat{\thepoints}

% Command for breakdown parts without total point(bd = breakdown)
\newcommand{\bdpart}[1][]{%
  \IfSubStr{#1}{+}{%
    \pointformat{#1}% No parentheses
    \part[0]% Use 0 or placeholder
    \pointformat{\thepoints}%
  }{%
    \part[#1]%
  }%
}