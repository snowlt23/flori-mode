
(setq flori-ident "\\(\\([a-z]\\|[A-Z]\\)\\([a-z]\\|[A-Z]\\|[0-9]\\|_\\)*?\\)")
(setq flori-separates "\\((\\|)\\|[\\|]\\|\s\\|\n\\|\r\\|,\\)")

(setq flori-keywords '("match" "if" "elif" "else" "cond" "for" "while" "import" "destructor" "return"))

(setq flori-keywords-regexp (regexp-opt flori-keywords 'words))
(setq flori-def-regexp (concat flori-ident "\s*:=\s*"))
(setq flori-defn-regexp (concat "\\(fn\\)\s" "\\(.+?\\)" flori-separates))
(setq flori-deftype-regexp (concat "\\(type\\)\s" "\\(.+?\\)" flori-separates))
(setq flori-type-regexp (concat "\\([A-Z]\\([a-z]\\|[A-Z]\\|[0-9]\\)*?\\)" flori-separates))
(setq flori-attr-regexp (concat flori-ident "\:" flori-separates))
(setq flori-constant-regexp (concat flori-separates "\\([0-9]\\([0-9]\\|\.\\)*?\\)" flori-separates))
(setq flori-string-regexp "\".*\"")

(setq flori-font-lock-keywords
      `((,flori-keywords-regexp . font-lock-keyword-face)
        (,flori-deftype-regexp (1 font-lock-variable-name-face))
        (,flori-defn-regexp (1 font-lock-keyword-face) (2 font-lock-function-name-face))
        (,flori-deftype-regexp (1 font-lock-keyword-face) (2 font-lock-function-name-face))
        (,flori-type-regexp (1 font-lock-type-face))
        (,flori-attr-regexp . font-lock-preprocessor-face)
        (,flori-constant-regexp (2 font-lock-constant-face))
        (,flori-string-regexp . font-lock-string-face)))

(defun flori-indent-line ()
  (interactive)
  (beginning-of-line)
  (save-excursion
    (if (looking-at "^[ \t]*\}")
        (indent-line-to (* 2 (- (car (syntax-ppss)) 1)))
      (indent-line-to (* 2 (car (syntax-ppss))))))
  (back-to-indentation))
(defun flori-indent-region (beg end)
  (interactive)
  (indent-region beg end nil))

(defvar flori-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?_ "w" st)
    (modify-syntax-entry ?\" "\"" st)
    (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?\n "> st")
    (modify-syntax-entry ?\{ "(")
    (modify-syntax-entry ?\} ")")
    st))

(define-derived-mode flori-mode fundamental-mode "Flori"
  :syntax-table flori-mode-syntax-table
  (setq indent-tabs-mode nil)
  (setq indent-line-function #'flori-indent-line)
  (setq comment-start ";;")
  (setq font-lock-defaults '(flori-font-lock-keywords)))
(font-lock-add-keywords 'flori-mode
                        '(("set!" . font-lock-keyword-face)))
(font-lock-add-keywords 'flori-mode
                        '(("destructor" . font-lock-builtin-face)))

(provide 'flori-mode)
(add-to-list 'auto-mode-alist '("\\.flori$" . flori-mode))
