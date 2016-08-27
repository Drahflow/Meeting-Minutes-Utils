#!/usr/bin/ruby

puts <<'EOS'
\documentclass{article}
\usepackage[utf8]{inputenc}

\parindent 0pt
\reversemarginpar
\begin{document}
EOS

IO.foreach($*[0]) { |line|
  next unless line =~ /^=/ .. line =~ /^\[\[Kategorie/

  case line
  when /^=([^=].*[^=])=$/ then out = '\section{' + $1 + '}'
  when /^==([^=].*[^=])==$/ then out = '\subsection{' + $1 + '}'
  when /^===([^=].*[^=])===$/ then out = '\subsubsection{' + $1 + '}'
  when /^====([^=].*[^=])====$/ then out = '\paragraph{' + $1 + '}'
  when /^=====([^=].*[^=])=====$/ then out = '{\bf ' + $1 + '}'
  when /^<small>(.*)<\/small>(.*)$/ then out = '{\small ' + $1 + '}' + $2
  when /^<div style=".*float: right.*">([A-Z0-9]+)<\/div>(.*)/ then out = '\marginpar{\bf ' + $1 + '}' + $2
  when /^\}\}/ then out = nil
  when /^\|\}/ then out = nil
  else out = line
  end

  if out != nil
    out.gsub!(/\[(.*?)\]/, '{\\tt \1}');
    out.gsub!(/<br>/, '~\\\\\\\\');
    out.gsub!(/\[\[[^|]+\|(.*)\]\]/, '(\1)');
    out.gsub!(/<div style="background-color:#[^>]+>/, '');
    out.gsub!(/<\/div>/, '');
    out.gsub!(/<\/?pre>/, '"\'');
    out.gsub!(/^\*\*/, '~\\\\\\\\$~~~~~~\\cdot$ ');
    out.gsub!(/^\*/, '~\\\\\\\\$\\bullet$ ');
    out.gsub!(/_/, '\\_');
    out.gsub!(/&/) { '\\&' };
    out.gsub!(/„/) { '"`' };
    out.gsub!(/“/) { '"\'' };
    out.gsub!(/#/) { '\\#' };
    out.gsub!(/«/) { '"`' };
    out.gsub!(/»/) { '"\'' };
    out.gsub!(/–/) { '--' };
    out.gsub!(/‚/) { '"`' };
    out.gsub!(/’/) { '"\'' };
    out.gsub!(/€/) { 'EUR' };
    out.gsub!(/ﬂ/) { 'fl' };
    out.gsub!(/〈/) { '<' };
    out.gsub!(/¹/) { '${}^1$' };
    out.gsub!(/²/) { '${}^2$' };
    out.gsub!(/⇒/) { '$\Rightarrow$' };
    out.gsub!(/­/) { '' };
    out.gsub!(/ /) { '~' };
    out.gsub!(/%/) { '\\%' };
    out.gsub!(/</) { '$<$' };
    out.gsub!(/>/) { '$>$' };
    puts out
  end
}

puts <<'EOS'
\end{document}
EOS
