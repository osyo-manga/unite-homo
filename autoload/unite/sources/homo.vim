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
\	"description" : "homo"
\}
let s:source.hooks = {}

function! s:source.hooks.on_init(args, context)
	let a:context.source__counters = map(range(winheight("%")), "s:rand()%winwidth('%')")
endfunction


function! s:source.async_gather_candidates(args, context)
	let a:context.source.unite__cached_candidates = []

	let word = "三┌(┌ ＾o＾)┐".get(a:args, 0, "ﾎﾓｫ…")

	let counters = a:context.source__counters
	for n in range(len(counters))
		let counters[n] += 1
		if counters[n] > winwidth("%")
			let counters[n] = 0
		endif
	endfor

	return map(copy(counters), '{
\		"word" : s:resize(join(split((repeat(" ", v:val).word), "\\zs")[strchars(word) : winwidth("%")], ""), winwidth("%")-6)
\	}')
endfunction



