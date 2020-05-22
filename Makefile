NAME=cl-bb
CL=cl-launch
LISP=sbcl
SRCS=$(wildcard *.lisp)

.PHONY: clean

$(NAME): $(SRCS)
	$(CL) --output $(NAME) --dump ! --lisp $(LISP) --quicklisp --system $(NAME) --dispatch-system $(NAME)/pwd

clean:
	rm -f $(NAME) *.*fsl *.fasl
