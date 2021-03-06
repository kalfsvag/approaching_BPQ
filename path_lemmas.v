Require Import HoTT.

(** A few lemmas and definitions regarding path types we didn't find in the HoTT library. *)

(** A couple auxiliary lemmas we need  *)
Definition ap011_pp_pp {A B C : Type} (f : A -> B -> C) {x x' x'' : A} {y y' y'' : B}
           (p : x = x') (p' : x' = x'') (q : y = y') (q' : y' = y'') :
  ap011 f (p @ p') (q @ q') = ap011 f p q @ ap011 f p' q'.
Proof.
    by path_induction.
Qed.

Lemma ap011_VV
  : forall {A B C: Type} (f : A -> B -> C)
           {a0 a1 : A} {b0 b1 : B}
           (p : a0 = a1) (q : b0 = b1),
    (ap011 f p q)^ = ap011 f p^ q^.
Proof.
  intros. destruct p. destruct q. reflexivity.
Defined.

Definition double_pathover {A B : Type} (P : A -> B -> Type)
           {a a' : A} (p : a = a')
           {b b' : B} (q : b = b')
           (c : P a b) (c' : P a' b') : Type.
Proof.
  destruct p,q. exact (c = c').
Defined.

Definition double_pathover_to_path {A B : Type} (P : A -> B -> Type)
           {a a' : A} (p : a = a')
           {b b' : B} (q : b = b')
           (c : P a b) (c' : P a' b')
  : double_pathover P p q c c' ->
    transport (uncurry P) (path_prod (a,b) (a',b') p q) c = c'.
Proof.
  destruct p, q. exact idmap.
Defined.

Definition path_to_double_pathover {A B : Type} (P : A -> B -> Type)
           {a a' : A} (p : a = a')
           {b b' : B} (q : b = b') (c : P a b) (c' : P a' b')
  : transport (uncurry P) (path_prod (a, b) (a', b') p q) c = c' ->
    double_pathover P p q c c'.
Proof.
  destruct p. destruct q. exact idmap.
Defined.


Lemma path_arrow_V {A B : Type} {f g : A -> B} (H : f == g) :
  path_arrow g f (fun a => (H a)^) = (path_arrow f g H)^.
Proof.
  transitivity (path_arrow f g (ap10 (path_forall _ _ H)))^.
  - transitivity (path_arrow g f (fun a => (ap10 (path_forall _ _ H) a)^)).
    + apply (ap (path_arrow g f)). apply path_forall.
      intro a. apply (ap inverse). apply inverse. apply (ap10_path_arrow).
    +  destruct (path_forall f g H). simpl.
       destruct (path_forall _ _ (ap10_1 (f:= f)))^.
       destruct (path_arrow_1 f)^. reflexivity.
  - apply (ap inverse). apply (ap (path_arrow f g)). apply (path_forall _ _ (ap10_path_arrow f g H)).
Defined.

Definition path_prod_VV {A B : Type} (z z' : A*B) (p1 : fst z = fst z') (p2 : snd z = snd z') :
  path_prod z' z p1^ p2^ = (path_prod z z' p1 p2)^.
Proof.
  destruct z as [z1 z2]. destruct z' as [z1' z2']. simpl in *. destruct p1, p2. reflexivity.
Defined.



Definition path_triple_prod {A B C : Type} (a1 a2 : A * (B * C)) :
  (fst a1 = fst a2) * ((fst (snd a1) = fst (snd a2)) * (snd (snd a1) = snd (snd a2))) -> a1 = a2.
Proof.
  intros [p [q r]].
  apply (path_prod a1 a2 p (path_prod (_,_) (_,_) q r)).
Defined.

Definition equiv_path_triple_prod {A B C : Type} (a1 a2 : A * (B * C)) :
  (fst a1 = fst a2) * ((fst (snd a1) = fst (snd a2)) * (snd (snd a1) = snd (snd a2))) <~> a1 = a2.
Proof.
  srapply (@equiv_adjointify _ _ (path_triple_prod a1 a2)).
  - intro p.
    exact (ap fst p, (ap fst (ap snd p), (ap snd (ap snd p)))).
  - intros []. reflexivity.
  - intros [p [q r]].
    destruct a2 as [a2 [b2 c2]]. simpl in *.
    destruct p,q,r. reflexivity.
Defined.



