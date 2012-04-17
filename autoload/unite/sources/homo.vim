scriptencoding utf-8

function! unite#sources#homo#define()
	return s:source
endfunction

let s:RAND_MAX = 32767
let s:seed = 4239

function! s:rand()
  let s:seed = s:seed * 214013 + 2531011
  return (s:seed < 0 ? s:seed - 0x80000000 : s:seed) / 0x10000 % 0x8000
endfunction


function! s:resize(str, len)
	if  a:len <= 0
		return ""
	endif
	let list = split(a:str, '\zs')
	for n in range(a:len+1)
		let b = a:len < strwidth(join(list[ : n], ""))
		if b
			return n > 0 ? join(list[ : n-1], "") : ""
		endif
	endfor
	return a:str
endfunction


let s:source = {
\	"name" : "homo",
\	"description" : "homo",
\	"homo_counters" : map(range(winheight("%")), "s:rand()%100"),
\}


function! s:source.async_gather_candidates(args, context)
	let a:context.source.unite__cached_candidates = []

	let word = "三┌(┌ ＾o＾)┐ﾎﾓｫ…"
" 	let yuri = "三┌(┌ ＾o＾)┐ゆりぃ"

	for n in range(len(self.homo_counters))
		let self.homo_counters[n] = self.homo_counters[n] + 1
		if self.homo_counters[n] > winwidth("%")
			let self.homo_counters[n] = 0
		endif
	endfor

	return map(copy(self.homo_counters), '{
\		"word" : s:resize(join(split((repeat(" ", v:val).word), "\\zs")[18 : winwidth("%")], ""), winwidth("%")-10)
\	}')
endfunction



