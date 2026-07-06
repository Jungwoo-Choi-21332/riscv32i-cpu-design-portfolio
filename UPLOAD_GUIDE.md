# GitHub Upload Guide

이 폴더는 바로 GitHub 저장소로 올릴 수 있게 정리되어 있습니다.

## 1. Local Git Repository

```powershell
cd "C:\cpu 설계\riscv32i-cpu-design-portfolio"
git init
git add .
git commit -m "Organize RV32I CPU design portfolio"
```

## 2. GitHub Repository

GitHub에서 새 repository를 만듭니다.

- Owner: `Jungwoo-Choi-21332`
- Repository name: `riscv32i-cpu-design-portfolio`
- Visibility: public 또는 private 선택
- README 생성 옵션은 끄는 것을 권장합니다. 이 폴더에 이미 `README.md`가 있습니다.

## 3. Remote 연결 및 Push

```powershell
git branch -M main
git remote add origin https://github.com/Jungwoo-Choi-21332/riscv32i-cpu-design-portfolio.git
git push -u origin main
```

## Safety Check

업로드 전 아래 항목은 포함하지 않는 것이 좋습니다.

- GitHub token
- SSH private key
- `access_info.txt`
- simulator generated files: `simv`, `csrc`, `*.fsdb`, `*.vpd`
- 원본 대용량 압축파일

현재 포트폴리오 폴더는 위 항목을 제외하는 방향으로 정리되어 있으며, `.gitignore`에도 재유입 방지 규칙을 넣었습니다.

