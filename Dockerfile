#FROM ocaml/opam:ubuntu-18.04-ocaml-4.06
FROM ocaml/opam:ubuntu-20.04-ocaml-4.06 as build
RUN sudo apt-get update && sudo apt-get install -y build-essential m4 make gcc perl git automake autoconf libtool pkg-config wget  \
    gcc-multilib libc6-dev-i386 libgmp-dev \
    libgcrypt20-dev ocaml ocaml-findlib opam m4

USER opam

COPY . /obliv-c
WORKDIR /obliv-c
RUN sudo chmod -R 777 /obliv-c
RUN sudo chown -R opam:opam /obliv-c

RUN --mount=type=cache,target=/home/opam/.opam/4.06.0 \
    opam init -y --disable-sandboxing --compiler=4.06.0 # && opam switch create 4.06.0
RUN --mount=type=cache,target=/home/opam/.opam/4.06.0 \
    eval $(opam env) && ocaml -version && opam install -y camlp4 ocamlfind ocamlbuild batteries num

#STEP 15/16: RUN opam install -y camlp4 ocamlfind ocamlbuild batteries num
#The following actions will be performed:
#  - install ocamlbuild               0.14.3
#  - install ocaml-secondary-compiler 4.14.2 [required by ocamlfind-secondary]
#  - install num                      1.5-1
#  - install ocamlfind                1.9.6
#  - install camlp4                   4.06+1
#  - install ocamlfind-secondary      1.9.6  [required by dune]
#  - install dune                     3.17.2 [required by batteries]
#  - install camlp-streams            5.0.1  [required by batteries]
#  - install batteries                3.9.0
#===== 9 to install =====

RUN sudo chmod -R 777 /obliv-c
RUN eval $(opam env)  \
    && ocaml -version  \
    && sudo chown -R opam:opam /obliv-c \
    && ./configure  \
    && sudo chmod -R 777 /obliv-c  \
    && make && echo SUCCESS \
    || true

#FROM ocaml/opam:ubuntu-20.04-ocaml-4.06 AS export
#COPY --from=build /obliv-c /obliv-c
#COPY --from=build /home/opam/.opam /home/opam/.opam



#https://chatgpt.com/share/69018db8-af70-800a-8875-3bb052cff408