\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fstyrdok}
\renewcommand\@currname{fstyrdok}
\LoadClass[10pt,a4paper]{article}

% Paket för att kunna ta emot options på formatet key=value
\RequirePackage{kvoptions}
%\SetupKeyvalOptions{family=fstyrdok,prefix=}

%-----------------------------------------------------------%
%			OPTIONS FÖR KLASSEN FSEKT-STYRDOK		%
%-----------------------------------------------------------%
% Options till inputenc och babel
% Defaultvärden är satta för att passa för dokument på svenska i skolans IT-miljö.
\DeclareStringOption[latin1]{inputenc}
\DeclareStringOption[swedish]{language}

% Genvägar för att tillåta olika dokumenttyper
\newcounter{doctypes}
\newcommand\doctype{none}
\newcommand\allowdoctype[1]
{
	\DeclareVoidOption{#1}{
		\stepcounter{doctypes}
		\renewcommand\doctype{#1}
		\ClassInfo{Setting the document type to #1}
	}
}

% Options som visar vilken dokumenttyp som ska användas.
% Exakt en av dessa måste anges.
% Om en doctype läggs till i listan, behöver även makrona i 
% "MAKRON FÖR FÖRENKLING AV SWITCH PÅ DOCTYPE..." uppdateras
\allowdoctype{stadgar}
\allowdoctype{allapm}
\allowdoctype{pm}

% Processa alla options
\ProcessKeyvalOptions{fstyrdok}

%-----------------------------------------------------------%
%			PAKET SOM BEHÖVS FÖR ATT RESTEN 		%
%			AV KLASSEN SKA FUNGERA				%
%			(eller som bara är grymma...)			%
%-----------------------------------------------------------%
\makeatletter
\typeout{\@currname}
% inputenc: Gör det möjligt att använda specialtecken som å, ä och ö.
\RequirePackage[\fstyrdok@inputenc]{inputenc}
% babel: Avstavning, rubriker på innehållsförteckning m.m., språkanpassat
\RequirePackage[\fstyrdok@language]{babel}
\makeatother
% fontenc: Använd T1 som font encoding, för att inte få andra teckenproblem
\RequirePackage[T1]{fontenc}
% ifthen: Logisk programmering i latex
\RequirePackage{ifthen}
% fancyhdr: Sidhuvud, sidfot mm.
\RequirePackage{fancyhdr}
% lastpage: Ger kommandot \LastPage som kan användas överallt för att ange sista sidan.
\RequirePackage{lastpage}
% amsmath, amssymb: Kommandon och tecken för matte på alla möjliga sätt
\RequirePackage{amsmath}
\RequirePackage{amssymb}
% multirow, multicol: Tabellceller som spänner över flera rader/kolumner
\RequirePackage{multirow}
\RequirePackage{multicol}
% titlesec, enumitem, tocloft: Ger mer kontroll över numrering av sektioner och listor
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{tocloft}
% graphicx: Inkludera bilder (t.ex. sektionsloggan)
\RequirePackage{graphicx}
% xcolor: Gör färghantering mycket smidigare
\RequirePackage[hyperref]{xcolor}
% hypphenat: Snyggare -
\RequirePackage{hyphenat}
% hyperref: Skapar bokmärken i pdf-filer, gör hänvisningar till länkar, mm
\definecolor{orange}{wave}{612.2}\definecolor{dark-blue}{rgb}{0,0,.1}
\RequirePackage[pdftex,bookmarks,colorlinks,linkcolor=dark-blue]{hyperref}

%-----------------------------------------------------------%
%			MAKRON FÖR ATT FÖRENKLA SWITCH		%
%			BEROENDE PÅ VILKEN DOCTYPE SOM		%
%			ANVÄNDS						%
%-----------------------------------------------------------%
% Kolla att endast en doctype används
\ifthenelse{\equal{\arabic{doctypes}}{1}}
{\typeout{Dokumenttyp: \doctype}}
{
	\ifthenelse{\arabic{doctypes}>1}
	{	\ClassError
			{fstydrok}
			{För många dokumenttyper angedda!}
			{Du måste ange exakt 1 dokumenttyp. Tillgängliga dokumenttyper är "pm", "allapm" och "stadgar", och du anger en av dem som option till dokumentklassen "fstyrdok".}
	}
	{
		\ClassError
			{fstyrdok}
			{Ingen dokumenttyp angedd!}
			{Du måste ange exakt 1 dokumenttyp. Tillgängliga dokumenttyper är "pm", "allapm" och "stadgar", och du anger en av dem som option till dokumentklassen "fstyrdok".}
	}
}
% Makron för snabb koll mot de olika dokumenttyperna 
\newcommand\isstadgar{\equal{\doctype}{stadgar}}
\newcommand\ispm{\equal{\doctype}{pm}}
\newcommand\isallapm{\equal{\doctype}{allapm}}

%-----------------------------------------------------------%
%			FONT- OCH STYCKESINSTÄLLNINGAR		%
%-----------------------------------------------------------%
% Ta bort styckesindrag, och skiljd stycken med blankrader
\setlength\parindent{0pt}
\setlength\parskip{5pt}
\setlength\jot{5pt}
% Ger Computer modern roman som standardfont.
\RequirePackage{bookman}
%\newcommand\thefont{cmr}
%\renewcommand\rmdefault{\thefont}
%\font\smallt=\thefont12 at 14pt
%\font\cap=\thefont12 at 8pt

%-----------------------------------------------------------%
%			SEKTIONSRELATERADE SYMBOLER 			%
%-----------------------------------------------------------%
% fkm*
\DeclareRobustCommand{\fkm}{\ensuremath{\lowercase{\mathrm{\raisebox{-0.1ex}{\rotatebox{22}{f}}\!\raisebox{0.2ex}{\rotatebox{-15}{k}}\!m^{*}}}}}
% Chargé d'Affaires
\DeclareRobustCommand{\cda}{Charg\'e d'Affaires}
% n0ll
\DeclareRobustCommand{\noll}{n\ensuremath{\emptyset}ll}

%-----------------------------------------------------------%
%			FÄLTDEFINITIONER OCH ANNAT			%
%			FÖR TITELSIDA, INNEHÅLSFÖRTECKNING		%
%			OCH ÄNDRINGSHSTORIK				%
%-----------------------------------------------------------%
\makeatletter

% Sidavdelare
\newcommand\HRule[1][1pt]{\rule{\linewidth}{#1}}

% \org{<organisation>}
\newcommand{\org}[1]{\def\@org{#1}}
\@ifundefined{@org}{\org{Fysiksektionen, THS}}{}

% Lista över ändringar
\newcommand\changed[3]{#1 & #2 & #3\\}
\newcommand\@history{}
\newcommand\history[1]{
\renewcommand\@history{
\begin{tabular}{lll}
Datum & Sammanträde & Avsnitt\\
\hline
#1
\end{tabular}
}
}

% Ny definiton av titel
\renewcommand\maketitle{
	\hypersetup{pdftitle={\@title},pdfauthor={\@author}}
    \begin{flushright}
	\includegraphics[width=3cm]{kugghjul}
	\vskip 2cm
	{\LARGE \textsc{\@title} \\ \HRule}
    	{\large \@org}
	{\small\par Uppdaterat \@date}
  \end{flushright}
}

\newcommand\frontmatter{
	% Sidnummer i romerska siffor
	\pagenumbering{roman}
	\pagestyle{plain}
}
\newcommand\mainmatter{
	% Sidnummer i arabiska siffror
	\pagenumbering{arabic}
	\pagestyle{fancy}
}

% Kommando för innehållsförteckning med bokmärke i PDF-filen
\newcommand\ftoc{\pdfbookmark[2]{Innehåll}{toc}\tableofcontents}

% Enkelt kommando för titelblad och innehållsförteckning
\ifthenelse{\isstadgar\OR\isallapm}
{ % Stadgar eller alla pm (lång titelsida, innehållsförteckning etc)
	\newcommand\ftitlepage
	{
		\begin{titlepage}
		\maketitle
		\newpage\frontmatter
		% Visa bara ändringshistoriken först för stadgar
		\ifthenelse{\isstadgar}{\showhistory}{}
		\ftoc
		\end{titlepage}
		\newpage\mainmatter
	}
}
{ % Bara ett PM (Titelsida med ändringshistorik)
	\newcommand\ftitlepage
	{
		\begin{titlepage}
			\maketitle
			\showhistory
			\thispagestyle{empty}
		\end{titlepage}
	}
}

% Ändringshistorik
\ifthenelse{\ispm\OR\isstadgar}
{
	\newcommand\showhistory{
	\section*{Ändringshistorik}
	\@history
	}
}
{
	\newcommand\showhistory{
	\subsection*{Ändringshistorik}
	\@history
	}
}


\makeatother

%-----------------------------------------------------------%
%			SIDHUVUD OCH SIDFOT				%
%-----------------------------------------------------------%
\makeatletter
% \orgnr{<organisationsnummer>}
\newcommand\orgnr[1]{\def\@orgnr{#1}}
\@ifundefined{@orgnr}{\orgnr{802411-8948}}{}

% \bank{<bankinformation>}
\newcommand\bank[1]{\def\@bank{#1}}
\@ifundefined{@bank}{\bank{BG 5942-8102}}{}
% \postadress{<postadress>}
\newcommand\postadress[1]{\def\@postadress{{#1}}}
\@ifundefined{@postadress}{\postadress{Box 100 44 Stockholm}}{}

% \website{<url>}
\newcommand\web[1]{\def\@web{#1}}
\@ifundefined{@web}{\web{ordf@f.kth.se\\www.f.kth.se}}{}

\pagestyle{fancy}
\fancyhead[R]{\textsc{\@title}\\Sid \thepage\ av \pageref{LastPage}}
\fancyhead[L]{{\Huge \color{orange} $\mathfrak{F}$}\vspace{.1em}}
\fancyfoot[L]{\parbox{6cm}{\small \@org\\\@postadress}}
\fancyfoot[C]{\parbox{5cm}{\small Organisationsnr: \@orgnr\\\@bank}}
\fancyfoot[R]{\parbox{3cm}{\small \@web}\flushright}

\renewcommand{\headrulewidth}{1pt}
\renewcommand{\footrulewidth}{1pt}
\addtolength\headheight{3em}

\makeatother

%-----------------------------------------------------------%
%			LISTMILJÖER FÖR PARAGRAFER			%
%-----------------------------------------------------------%
\newenvironment{punkter}{\begin{enumerate}}{\end{enumerate}}
\newcommand\punkt{\normalfont\item}
\newcommand\fetpunkt{\normalfont\item\bfseries}
\newcommand\attpunkt{\normalfont\item\textbf{att}\ }
\newcommand\tompunkt{\normalfont\item\hspace{1em}}

\newcommand\paragraf[1]{#1 \S}
\newcommand\setupenumerate[3]{
	\setenumerate[#1]{label={#2 #3},leftmargin=6em}
}

\newcommand\resetpunkter{\setupenumerate{1}{\arabic*~\S~}{}}

\setlength\cftsecnumwidth{2.2em}
\setlength\cftsubsecnumwidth{4em}

\ifthenelse{\ispm\OR\isstadgar} % STADGAR ELLER PM
{
	\renewcommand\thesection{\arabic{section}~\S~}
	\renewcommand\thesubsection{\thesection~\arabic{subsection}.}
	\newcommand\header[1]
	{
		\section{#1}
		\setupenumerate{1}{\thesection}{\arabic*.}
	}
	\newcommand\subheader[1]
	{
		\subsection{#1}
		\setupenumerate{1}{\thesection}{\arabic{subsection}.\arabic*.}
	}
}{}
\ifthenelse{\isallapm} % ALLA PM
{
	\renewcommand\thesubsection{\arabic{subsection}~\S~}
	\titleformat{\section}{\bf \sc \Large}{}{0em}{}
	\renewcommand\thesubsubsection{\thesubsection\ \arabic{subsubsection}}
	\setupenumerate{1}{\arabic.~\S~}{}

	\newcommand\header[1]
	{
		\subsection{#1}
		\setupenumerate{1}{\thesubsection}{\arabic*.}
	}
	\newcommand\subheader[1]
	{
		\subsubsection{#1}
		\setupenumerate{1}{\thesubsubsection}{\arabic*.}
	}
	
	\newcommand\pminput[2]{
		\newpage
		\section{#1}
		\resetpunkter
		\input{#2}
		\showhistory
	}
}
{
}

\setenumerate[2]{label*=\arabic*.}
\setenumerate[3]{label*=\arabic*.}
\setenumerate[4]{label*=\arabic*.}