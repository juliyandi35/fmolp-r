%inisialisasi sumber dan tujuan
gudang = ['Gudang Ninja Xpress'];
tujuan = ['Galang', 'Bangun Purba','Bintang Bayu', 'Gunung Meriah', 'Kotarih',...
    'Pagar Merbau', 'Pegajahan', 'Serba Jadi', 'Silinda','Silau Kahean', ...
    'STM Hilir', 'STM Hulu','Tiga Juhar'];
jmlgudang = 1;
jmltujuan = 13;

%mulai dari data ukuran Large
%mengambil data masukan dari file excel
biaya = xlsread('D:\Kerjaan\Project FMOLP\Data bintang FIX.xlsx','Large','B2:B14');
waktu = xlsread('D:\Kerjaan\Project FMOLP\Data bintang FIX.xlsx','Large','C2:C14');
S = xlsread('D:\Kerjaan\Project FMOLP\Data bintang FIX.xlsx','Large','G2');
A = xlsread('D:\Kerjaan\Project FMOLP\Data bintang FIX.xlsx','Large','D2:D14');
D = xlsread('D:\Kerjaan\Project FMOLP\Data bintang FIX.xlsx','Large','E2:E14');


%inisialisasi variabel deviational non negatif
x = 6;
y = 4;
z = 2;
t = waktu';

%fungsi tujuan memaksimalkan L
dvar = zeros(1,20);
for i = 1:jmlgudang
    for j = 1:jmltujuan
        dvar(i,j) = 0;
    end
end

for i = 1:x
    dvar(1,13+i) = 0;
end

dvar(1,20) = 1;
fo = dvar;

%membuat array untuk variabel keputusan, batas atas, dan batas bawah
dvar = zeros(1,20);
Q = zeros(0,20);
bU = zeros(0,1);
bL = zeros(0,1);

%memasukkan batasan pertama FMOLP
c = biaya';
dvar = zeros(1,20);
for i = 1:jmlgudang
    for j = 1:jmltujuan
        dvar(i,j) = c(i,j).*0.0000000035;
    end
end

dvar(1,14) = 0.000000001;
dvar(1,15) = -0.000000001;
dvar(1,16) = 0.0000000005;
dvar(1,17) = -0.0000000005;

for i = 1:z
    dvar(1,17+i) = 0;
end

dvar(1,20) = 1;
Q(size(Q,1)+1,:) = dvar;
bU(size(bU,1)+1,1) = inf;
bL(size(bL,1)+1,1) = 1.53;

%memasukkan batasan ketiga FMOLP
dvar = zeros(1,20);
for i = 1:jmlgudang
    for j = 1:jmltujuan
        dvar(i,j) = c(i,j);
    end
end

dvar(1,14) = 1;
dvar(1,15) = -1;
Q(size(Q,1)+1,:) = dvar;
bU(size(bU,1)+1,1) = 280000000;
bL(size(bL,1)+1,1) = 280000000;

%memasukkan batasan keempat FMOLP
dvar = zeros(1,20);
for i = 1:jmlgudang
    for j = 1:jmltujuan
        dvar(i,j) = c(i,j);
    end
end

dvar(1,18) = 1;
dvar(1,17) = -1;
Q(size(Q,1)+1,:) = dvar;
bU(size(bU,1)+1,1) = 180000000;
bL(size(bL,1)+1,1) = 180000000;

%memasukkan batasan kelima FMOLP
dvar = zeros(1,20);
for i = 1:jmlgudang
    for j = 1:jmltujuan
        dvar(i,j) = t(i,j);
    end
end

dvar(1,18) = 1;
dvar(1,19) = -1;
Q(size(Q,1)+1,:) = dvar;
bU(size(bU,1)+1,1) = 300000;
bL(size(bL,1)+1,1) = 300000;

%memasukkan batasan keenam FMOLP
for i = 1:jmlgudang
    dvar = zeros(1,20);
    for j = 1:jmltujuan
        dvar(i,j) = 1;
    end
    Q(size(Q,1)+1,:) = dvar;
    bU(size(bU,1)+1,1) = S(i);
    bL(size(bL,1)+1,1) = -inf;
end

%memasukkan batasan ketujuh FMOLP
for j = 1:jmltujuan
    dvar = zeros(1,20);
    for i = 1:jmlgudang
        dvar(i,j) = 1;
    end
    Q(size(Q,1)+1,:) = dvar;
    bU(size(bU,1)+1,1) = inf;
    bL(size(bL,1)+1,1) = D(j);
end

%memasukkan batasan kedelapan FMOLP
for j = 1:jmltujuan
    dvar = zeros(1,20);
    for i = 1:jmlgudang
        dvar(i,j) = 1;
    end
    Q(size(Q,1)+1,:) = dvar;
    bU(size(bU,1)+1,1) = A(j);
    bL(size(bL,1)+1,1) = -inf;
end

%memasukkan batasan atas dan batasan bawah hasil
x_L = zeros(20,1);
x_U = [inf(19,1);ones(1,1)];

%eksekusi model%
IntVars = false(20,1);
Prob = mipAssign(fo, Q, bL, bU, x_L,x_U, [], [], [], ...
    [], IntVars, [], 1, [], [], ...
    [], [], [], [], []);
Result = mipSolve(Prob)
x = Result.x_k;
fval = Result.f_k;
