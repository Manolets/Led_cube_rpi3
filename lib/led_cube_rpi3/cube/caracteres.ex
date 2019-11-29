defmodule LedCubeRpi3.Caracteres do
  @letras %{
    a: [:ac, :ad, :bb, :be, :cb, :ce, :da, :db, :de, :df, :ea, :ef, :fa, :ff],
    b: [
      :aa,
      :ab,
      :ac,
      :ad,
      :ae,
      :ba,
      :bf,
      :ca,
      :cb,
      :cd,
      :ce,
      :da,
      :df,
      :ea,
      :ef,
      :fa,
      :fb,
      :fc,
      :fd,
      :fe
    ],
    c: [:aa, :ab, :ac, :ad, :ae, :af, :ba, :ca, :da, :ea, :fa, :fb, :fc, :fd, :fe, :ff],
    d: [
      :aa,
      :ab,
      :ac,
      :ad,
      :ae,
      :ba,
      :be,
      :ca,
      :ce,
      :cf,
      :da,
      :df,
      :ea,
      :ef,
      :fa,
      :fb,
      :fc,
      :fd,
      :fe
    ],
    e: [
      :aa,
      :ab,
      :ac,
      :ad,
      :ae,
      :af,
      :ba,
      :ca,
      :da,
      :db,
      :dd,
      :de,
      :df,
      :ea,
      :fa,
      :fb,
      :fc,
      :fd,
      :fe,
      :ff
    ],
    f: [:aa, :ab, :ac, :ad, :ae, :af, :ba, :ca, :da, :db, :dd, :de, :ea, :fa],
    g: [
      :aa,
      :ab,
      :ac,
      :ad,
      :ae,
      :af,
      :ba,
      :ca,
      :da,
      :dd,
      :de,
      :df,
      :ea,
      :ef,
      :fa,
      :fb,
      :fc,
      :fd,
      :fe,
      :ff
    ],
    h: [:aa, :af, :ba, :bf, :ca, :cf, :da, :db, :dd, :de, :df, :ea, :ef, :fa, :ff],
    i: [],
    j: [],
    k: [],
    l: [:aa, :ba, :ca, :da, :ea, :fa, :fb, :fc, :fd, :fe, :ff],
    m: [],
    n: [],
    o: [],
    p: [],
    q: [],
    r: [
      :aa,
      :ab,
      :ac,
      :ad,
      :ae,
      :af,
      :ba,
      :bf,
      :ca,
      :cb,
      :cd,
      :ce,
      :cf,
      :da,
      :dd,
      :ea,
      :ee,
      :fa,
      :ff
    ],
    s: [],
    t: [],
    u: [],
    v: [],
    w: [],
    x: [],
    y: [],
    z: []
  }

  @ascii %{
    heart: [:ab, :ae, :ba, :bc, :bd, :bf, :ca, :cf, :db, :de, :eb, :ec, :ed, :ee, :fc, :fd]
  }

  def select_case(char) do
    case char do
      "a" ->
        @letras.a

      "b" ->
        @letras.b

      "c" ->
        @letras.c

      "d" ->
        @letras.d

      "e" ->
        @letras.e

      "f" ->
        @letras.f

      "g" ->
        @letras.g

      "h" ->
        @letras.h

      "i" ->
        @letras.i

      "j" ->
        @letras.k

      "l" ->
        @letras.l

      "m" ->
        @letras.m

      "n" ->
        @letras.n

      "o" ->
        @letras.o

      "p" ->
        @letras.p

      "q" ->
        @letras.q

      "r" ->
        @letras.r

      "s" ->
        @letras.s

      "t" ->
        @letras.t

      "u" ->
        @letras.u

      "v" ->
        @letras.v

      "w" ->
        @letras.w

      "x" ->
        @letras.x

      "y" ->
        @letras.y

      "z" ->
        @letras.z

      "@" ->
        @ascii.heart
    end
  end
end
