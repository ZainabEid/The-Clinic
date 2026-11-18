FIRST QUESTIONS TO BUSINESS (DOCTOR/OWNER)
(to know the function requirements: What)
1- who is users? who update them? what is their types? their roles?
2- Main Flow from patient create reservation to the end of the visit
3- numbers : how many reservation daily ? when is the rush time?
4- constrains: should system work offline? are their any sensitive infromation about patients ? 

non-Function Requiremnet(How):

[1] Race Conditions (over booking) : 
    اتنين محتلفين  بيحجزو نفس معاد او نفس طلب في نفس الوقت والمتاح واحد فقط -
    solution : 
    1- (passimistic sol) lock [SELECT ... FOR UPDATE] + short transaction [insert , update , check] 
            - lock should be released as soon as possible ,
            - if more than recored should be locked must be ordered by (ex. id) to avoid deadlock
            - use [lock timeout] to avoid lock for long time or when use [wait] then rollback and throw error or retry
            - when retry .. use limited times (ex. 3 retries) , 
    أنسب لو التعارض متكرر زي الفترات اللي بتتملي بسرعة
    2-(optimistic sol) atomic operation [UPDATE slots SET booked = booked + 1, version = version + 1 WHERE id = ? AND version = ? AND booked < capacity] فنرجع للمريض برسالة واضحة أو نقترح فترة تانية. ده  البديل المناسب لو التعارض نادر

[2] Concurrency 
ازاي يعرف انه نفس الطلب لو ضغط اكتر من مره ؟ ويعمل ايه لما يعرف ؟
    1- Idempotancy key [client side UUID with each supmission]
    2- store idempotancy key in same transaction with create reservation
    3- Unique Index Constraint in same table [ALTER TABLE appointments ADD UNIQUE (idempotency_key);]

لو ملاء نفس البيانات وضغط مره تانيه وحجز نفس المعاد ؟
    1- request fingerprint for short time (ex. 2 min)

لو الحجز نجح، لكن الـرد ضاع في الشبكة، المريض هيضغط تاني؟
    - النظام لازم يرجع نفس نتيجة الحجز الأول (نفس رقم الحجز)

لو حجزين بنفس المفتاح بس الاول جاري تسجيله لسه في قاعدة البيانات؟
    - idemoptancy_key $ idempotance_status stored in table idemmpotance and udated in same transaction 


  لو حجزين  بس  مفتاحين مختلفين الاول جاري تسجيله لسه في قاعدة البيانات؟  
    - هيتسجل في idempotancey وهيرجع من الcheck slot و برساله واضه الفنرخ اتحجزت للتو

