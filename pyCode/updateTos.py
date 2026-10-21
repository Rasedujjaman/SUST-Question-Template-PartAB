import re
import os

def update_latex_totals(filepath):
    # Resolve absolute path to make debugging directory errors easier
    abs_path = os.path.abspath(filepath)
    if not os.path.exists(abs_path):
        print(f"Error: Could not find the file at {abs_path}")
        print("Please check if the folder name is spelled exactly right (e.g., 'TexFiles' vs 'TexFile').")
        return

    with open(abs_path, 'r') as file:
        lines = file.readlines()

    data_rows = []
    
    for line in lines:
        stripped_line = line.strip()
        if re.match(r'^[0-9]+[a-z]?\s*&', stripped_line):
            parts = [p.strip() for p in stripped_line.split('&')]
            if len(parts) >= 9:
                parts[-1] = parts[-1].split('\\')[0].strip()
                data_rows.append(parts)

    bloom_totals = [0.0] * 6
    for row in data_rows:
        for i in range(6):
            val = row[i+3]
            if val:
                bloom_totals[i] += float(val)
                
    total_marks = sum(bloom_totals)

    def format_num(n):
        return str(int(n)) if n.is_integer() else str(n)

    total_marks_str = format_num(total_marks)
    bloom_totals_str = [format_num(n) for n in bloom_totals]
    
    percentages = [(n / total_marks) * 100 if total_marks > 0 else 0 for n in bloom_totals]
    percentages_str = [f"{p:.2f}" for p in percentages]

    major_1 = sum(percentages[:3])
    major_2 = sum(percentages[3:])

    # Fixed syntax warning by escaping the backslashes explicitly outside the f-string
    row1 = f"\\textbf{{Total}} & \\textbf{{{total_marks_str}}} & & " + " & ".join([f"\\textbf{{{x}}}" for x in bloom_totals_str]) + " \\\\ \\hline\n"
    row2 = f"\\multicolumn{{3}}{{|c|}}{{\\textbf{{Total \\% in each level}}}} & " + " & ".join([f"\\textbf{{{x}}}" for x in percentages_str]) + " \\\\ \\hline\n"
    row3 = f"\\multicolumn{{3}}{{|c|}}{{\\textbf{{\\% Marks in Major levels}}}} & \\multicolumn{{3}}{{c|}}{{\\textbf{{{major_1:.2f}}}}} & \\multicolumn{{3}}{{c|}}{{\\textbf{{{major_2:.2f}}}}} \\\\ \\hline\n"

    new_lines = []
    for line in lines:
        if line.strip().startswith(r'\textbf{Total} &'):
            continue
        if line.strip().startswith(r'\multicolumn{3}{|c|}{\textbf{Total \% in each level}}'):
            continue
        if line.strip().startswith(r'\multicolumn{3}{|c|}{\textbf{\% Marks in Major levels}}'):
            continue
        
        if r'\end{tabular}' in line:
            new_lines.extend([row1, row2, row3])
        
        new_lines.append(line)

    with open(abs_path, 'w') as file:
        file.writelines(new_lines)
    
    print(f"Successfully updated totals in: {abs_path}")

# Note the path is changed to 'TexFiles' based on your document's \input header
update_latex_totals('../TexFiles/tos.tex')
