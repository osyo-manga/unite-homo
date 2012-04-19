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
	let result = a:str
	while (strwidth(result) > a:len)
		let list = split(result, '\zs')
		if len(list) == 1
			return ""
		endif
		let result = join(list[ :len(list)-2], "")
	endwhile
	return result
endfunction


function! s:move(str, x)
	let list = split(a:str, '\zs')
	if a:x < 0
		return join(list[a:x * -1 : len(list)], "")
	endif
	return repeat("　", a:x).a:str
endfunction


let s:pattern_index = 0
let s:position = 0

function! s:get_homo(count)

	let s:pattern0 = [
		  \ '┌(┌　^ o^)┐',
		  \ '┌(　┐^ o^)┐',
		  \ '　┐ ┐^ o^)┐',
		  \ '三┌(┌　^ o^)  ',
		  \ '　┌(┌　^ o^)┐',
		  \]
	return s:pattern0[a:count % len(s:pattern0)]
endfunction


let s:source = {
\	"name" : "homo",
\	"description" : "homo"
\}
let s:source.hooks = {}

function! s:source.hooks.on_init(args, context)
	let a:context.source__counters = map(range(winheight("%")), "s:rand()%winwidth('%')*2")
endfunction

function! s:source.async_gather_candidates(args, context)
	let a:context.source.unite__cached_candidates = []

	let word = "三┌(┌ ＾o＾)┐".get(a:args, 0, "ﾎﾓｫ…")

	let counters = a:context.source__counters
	for n in range(len(counters))
		let counters[n] += 1
		if counters[n] > (winwidth("%")*2)
			let counters[n] = -strwidth(word)
		endif
	endfor

	return map(copy(counters), '{
\		"word" : s:resize(s:move(s:get_homo(v:val).get(a:args, 0, "ﾎﾓｫ…"), v:val > 0 ? v:val/5 : v:val), winwidth("%")-6)
\	}')
endfunction


